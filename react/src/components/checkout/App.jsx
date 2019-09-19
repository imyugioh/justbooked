import React from 'react';
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import DeliveryDetail from './DeliveryDetail'
import OrderDetail from './OrderDetail'
import PaymentDetail from './PaymentDetail'
import moment from 'moment'
import NotificationSystem from 'react-notification-system'
import * as CheckoutActions from '../../actions/checkout'
import roundTo from 'round-to'


import '../../../styles/react_styles.css';

class App extends React.Component {

	constructor(props) {
		super(props);

		this.state = {
			cart: window.getCartItems(),
			chef: window.cart_chef_info,
			order_sales_tax: 0.00,
			order_total: 0.0,
			total_fees: 0.00,
			delivery_fee: parseFloat(window.cart_chef_info.delivery_fee),
			delivery_distance: 3,
			delivery_address: '',
			order_type: 'delivery',
			order_date: moment().add(window.cart_chef_info.pre_order_notice_hour, 'hours').format("MM/DD/YYYY"),
			order_time: null,
      valid_order_time: true,
			delivery_more_detail: '',
			delivery_phone_number: '',
			cupon_code: '',
			first_name: '',
			last_name: '',
			email: '',
			delivery_distance: 0,
			max_delivery_distance: 0,
      delivery_warning: '',
      order_min_amount: 0
		}

		if (window.cart_user_info) {
			this.state.email = window.cart_user_info.email
			this.state.first_name = window.cart_user_info.first_name
			this.state.last_name = window.cart_user_info.last_name
		}

		if (window.cart_id) {
			this.state.cart_id = window.cart_id
		}

		if (window.cart_chef_info) {
			this.state.max_delivery_distance = window.cart_chef_info.max_delivery_distance

      // delivery min order amount becomes default min order amount
      this.state.order_min_amount = parseFloat(window.cart_chef_info.pre_order_min_order_amount)
		}


    this.state.first_possible_order_time = moment().add(window.cart_chef_info.pre_order_notice_hour, 'hours').format("h:mm A")

		this._messages = []
		this._notificationSystem =  null
		this.handleApplyCupon = this.handleApplyCupon.bind(this)
		this.getMenu = this.getMenu.bind(this)
		this.collectDeliveryDetail = this.collectDeliveryDetail.bind(this)

		this.handleLocationChange = this.handleLocationChange.bind(this)
		this.orderTotal = this.orderTotal.bind(this)
		this.salesTax = this.salesTax.bind(this)
		// this.deliveryFee = this.deliveryFee.bind(this)
		this.totalFees = this.totalFees.bind(this)
		this.deliveryDistance = this.deliveryDistance.bind(this)

		this.submitOrder = this.submitOrder.bind(this)
		this.collectFormSubmitParams = this.collectFormSubmitParams.bind(this)
    this.handleOrderTypeChange = this.handleOrderTypeChange.bind(this)


		this.addMenu = this.addMenu.bind(this)
		this.removeMenu = this.removeMenu.bind(this)
		this.removeMenus = this.removeMenus.bind(this)

    this.showMinOrderAlert = this.showMinOrderAlert.bind(this)
	}

	componentWillUpdate(nextProps, nextState) {
		// console.log("componentWillUpdate is called")
	}

  addMenu(menu_id) {
		let current_cart = Object.assign({}, this.state.cart)
		let items = current_cart[menu_id]
		let menu_item = _.clone(items[0], true);

		current_cart[menu_id].push(menu_item)

    window.add_cart_menu(menu_item)

    this.setState({cart: current_cart})
    this.adjustDeliveryFee()
	}

	removeMenu(menu_id) {
		let current_cart = Object.assign({}, this.state.cart)

		let menus = current_cart[menu_id]
		const idx = _.findIndex(menus, { menu_id: menu_id })

		if (idx > -1) {
			_.pullAt(menus, [idx])

      if (menus.length == 0) {
        delete current_cart[menu_id]
      } else {
        current_cart[menu_id] = menus
      }

			this.setState({cart: current_cart})
      this.adjustDeliveryFee()
			window.remove_cart_menu(menu_id)
		}
	}


	removeMenus(menu_id) {
		let current_cart = Object.assign({}, this.state.cart)

		const removing_count = current_cart[menu_id].length
		if (removing_count > 0) {
			delete current_cart[menu_id]
			this.setState({cart: current_cart})
			window.remove_all_cart_menus(menu_id)

		} else {
			console.log("can not find menu to delete: ", menu_id)
		}
    this.adjustDeliveryFee()
	}



  handleOrderTypeChange(order_type) {
    this.state.order_type = order_type
    // delivery min order amount becomes default min order amount
    if (order_type === 'onsite-cooking') {
      this.state.order_min_amount = parseFloat(this.state.chef.min_fee_for_onsite_cooking)
    } else {
      this.state.order_min_amount = parseFloat(this.state.chef.pre_order_min_order_amount)
    }

    if (order_type !== 'delivery') {
      this.setState({
        delivery_address: '',
        delivery_warning: '',
        delivery_fee: 0.0,
        delivery_distance: 0,
      })
    } else {
      this.setState({
        delivery_fee: this.state.chef.delivery_fee || 0
      })
    }

    this.adjustDeliveryFee()
  }


  adjustDeliveryFee() {
    if (this.state.order_type === 'delivery') {
      if (!this.state.chef.free_delivery_min_order_amount || (this.state.order_total < this.state.chef.free_delivery_min_order_amount)) {
        this.setState({
          delivery_fee: this.state.chef.delivery_fee || 0
        })
      } else {
        this.setState({
          delivery_fee: 0
        })
      }
    } else {
      this.setState({
        delivery_address: '',
        delivery_warning: '',
        delivery_fee: 0.0,
        delivery_distance: 0
      })
    }
  }


	submitOrder(e) {

    e.preventDefault()

    // Only allow order if all the necessary fields are entered
    if (this.checkoutReady(true) === 'disabled') {
      $(e.target).notify("Please check errors", {className: 'warn', position: 'top', autoHideDelay: 4000});
    	return false;
    }

    // Remove all invalid
    $('input').removeClass("invalidInput")

		if (this.orderTotal() < this.state.order_min_amount) {
			$('#minOrderAlert').modal('show');
		} else {
			const stripeTotalFee = Math.round(this.totalFees() * 100)
      // console.log("description: ", `$${this.totalFees()}`)
			// console.log("stripe payment fee: ", stripeTotalFee)
			const stripeHandler = StripeCheckout.configure({
				key: document.querySelector("meta[name='stripe-public-key']").content,
				token: (token, arg) => {
					const orderDetail = this.collectFormSubmitParams()
					document.getElementById("stripeToken").value = token.id
					document.getElementById("stripeEmail").value = token.email
					document.getElementById("stripeAmount").value = stripeTotalFee
					document.getElementById("orderDetail").value = JSON.stringify(orderDetail)
					document.getElementById("paymentForm").submit()

          // Clear cart
          window.clearCart();
				}
			})

      stripeHandler.open({
				name: 'Justbooked Order',
				email: this.state.email,
        description: `$${this.totalFees()}`,
				amount: stripeTotalFee
      })
		}

	}


	collectFormSubmitParams() {
		return {
			cart: this.state.cart,
			cart_id: this.state.cart_id,
			first_name: this.state.first_name,
			last_name: this.state.last_name,
			delivery_phone_number: this.state.delivery_phone_number,
      order_type: this.state.order_type,
			order_date: this.state.order_date,
			order_time: this.state.order_time,
			more_detail: this.state.delivery_more_detail,
			order_total: this.orderTotal(),
			order_sales_tax: this.salesTax(),
			delivery_distance: this.state.delivery_distance,
			delivery_fee: this.state.delivery_fee,
			total_fees: this.totalFees(),
			delivery_address: this.state.delivery_address,
			chef_id: this.state.chef.id
		}
	}


	collectDeliveryDetail(k, v) {
		const obj  = {}
		obj[k] = v

		if (k === 'order_date') {
			if (this.outsideOfNoticeHour()) {
				this.state.valid_order_time = true
			} else {
				this.state.valid_order_time = false
			}
		}

		console.log("valid: ", this.state.valid_order_time)
		this.setState(obj)
	}

	handleApplyCupon() {
		console.log("apply cupon")
	}

	componentDidMount() {
    this.adjustDeliveryFee()
		window.addEventListener("location_found", this.handleLocationChange)
		this._notificationSystem = this.refs.notificationSystem;
	}

	handleLocationChange(e) {
		// first clear warning
		$('#delivery_warning').html("")
    $('input').removeClass("invalidInput")

    if (this.state.order_type === 'delivery') {
      this.deliveryDistance(e.detail.lat, e.detail.lng, e.detail.address)
    } else {
      console.log("skipping handleLocation since order type is ", this.state.order_type)
    }
	}

	getMenu(menu_id) {
		const {menus} = this.props
		const i_menu_id = parseInt(menu_id)
		const found_menu = _.find(this.props.menus, {id: i_menu_id})
		return found_menu
	}


	deliveryDistance(lat, lng, address) {

		if (lat && lng && address) {
			this.state.delivery_address = address
			let distance = 0
			let directionsService = new google.maps.DirectionsService();

			const request = {
				origin: `${this.state.chef.latitude}, ${this.state.chef.longitude}`,
				destination: `${lat}, ${lng}`,
				waypoints: [],
				optimizeWaypoints: true,
				travelMode: 'DRIVING'
			}

			directionsService.route(request, (response, status) => {
				if (status === 'OK') {
					distance = response.routes[0].legs[0].distance.value / 1000
					distance = roundTo(distance, 2)
					// console.log("Distance: ", distance, " km")
					this.setState({
						delivery_distance: distance,
						delivery_fee: this.deliveryFee(distance)
					})
				} else {
					console.log("Can not calculate distance")
					console.log(response)
				}
			})
		} else {
			console.log(">>> deliveryDistance can not geo code")
			console.log("lat: ", lat, " lng: ", lng, " address: ", address)
		}
	}


	orderTotal() {
		let total = 0.0

		// for(let menus of Object.values(this.state.cart)) {
		// 	for(let menu of menus) {
		// 		if (menu.amount && menu.unit_price) {
		// 			total += menu.amount * menu.unit_price
		// 		}
		// 	}
		// }
		this.state.cart.forEach(element => {
			total += parseFloat(element.total);
		});

		total = roundTo(total, 2)
		this.state.order_total = total
		return total
	}

	salesTax() {
		let sales_tax = (this.orderTotal() + this.state.delivery_fee) * 0.13
		this.state.order_sales_tax = sales_tax
		return sales_tax
	}


	// deliveryFee(distance) {
	// 	let fee = 0
	// 	const fee_per_km = 1.0;

	// 	if (this.orderTotal() > 0) {
	// 		fee = distance * fee_per_km
	// 	}
	// 	return roundTo(fee, 2)
	// }

	deliveryFee() {
		if (this.state.order_type === 'delivery') {
      console.log(this.state.delivery_fee)
			return this.state.delivery_fee
		} else {
			return 0.0;
		}
	}


	totalFees() {
		let total_fees = this.orderTotal() + this.state.delivery_fee + this.state.order_sales_tax
		this.state.total_fees = roundTo(total_fees, 2)
		return this.state.total_fees
	}

	checkoutReady(showError = false) {
		let result = ""

		if (this.state.email.trim().length == 0) {
			if (showError) { $(`#order_email`).addClass("invalidInput") }
			this._messages.push("email missing")
		}

		if (this.state.delivery_phone_number.trim().length == 0) {
			if (showError) { $(`#order_delivery_phone_number`).addClass("invalidInput") }
			this._messages.push("phone number missing")
		}

		if (this.state.first_name.trim().length == 0) {
			if (showError) { $(`#order_first_name`).addClass("invalidInput") }
			this._messages.push("first name missing")
		}

		if (this.state.last_name.trim().length == 0) {
			if (showError) { $(`#order_last_name`).addClass("invalidInput") }
			this._messages.push("last name missing")
		}

		if (this.state.order_date.trim().length == 0) {
			if (showError) { $(`#order_date`).addClass("invalidInput") }
			this._messages.push("delivery date missing")
		}

    if (this.state.order_type === 'delivery') {
      if (this.state.delivery_address.trim().length == 0) {
        if (showError) { $(`#delivery_address`).addClass("invalidInput") }
        this._messages.push("delivery address missing")
      }

      if (this.state.max_delivery_distance < this.state.delivery_distance) {
        if (showError) {
          $(`#delivery_address`).addClass("invalidInput")
          $(`#delivery_distance`).addClass("invalidInput")
        }
        const warning_message = `chef can only deliver up to ${this.state.max_delivery_distance} km distance`
        this._messages.push(warning_message)
        this.state.delivery_warning = warning_message
      }
    }

    if (!this.state.order_time && this.outsideOfNoticeHour() == false) {
      if (showError) { $(`#order_time`).addClass("invalidInput") }
      this.state.valid_order_time = false
      this._messages.push("Please select delivery time")
    } else {
      if (this.outsideOfNoticeHour()) {
      	this.state.valid_order_time = true
      	if (showError) { $(`#order_time`).removeClass("invalidInput") }
      } else {
        $('#order_time').addClass("invalidInput")
        this.state.valid_order_time = false
        this._messages.push(`At least ${this.state.pre_order_notice_hour} hours notice please`)
      }
    }

		if (this.orderTotal() < this.state.min_order_amount) {
			this._messages.push(`Minimum order is $${this.state.min_order_amount} for this chef`)
		}

		if (this._messages.length > 0) {
			// console.log(this._messages)
			result = "disabled"
			this._messages = []
		} else {
			// console.log("should enable the button")
			result = ""
		}
		return result
	}

	outsideOfNoticeHour() {
    let rightNow = moment()
    let order_time_string = this.state.order_time || "00:00 AM"

    let selectedTime = moment(`${this.state.order_date} ${order_time_string}`, "MM/DD/YYYY HH:mm A")
    let duration = moment.duration(selectedTime.diff(rightNow))
    let hours = parseInt(duration.asHours())

    if (hours < this.state.chef.pre_order_notice_hour) {
      return false
    } else {
    	return true
    }
	}

  showMinOrderAlert() {
    $('#minOrderAlert').modal('hide')
  }

	render() {
		const { actions } = this.props
		let checkoutReady = this.checkoutReady()

		return (
			<div>
				<div className="row">
					<div className="row checkout">
						<div className="col-12 col-lg-7">
							<DeliveryDetail
								submit={this.collectDeliveryDetail}
								chef={this.state.chef}
                possible_order_time={this.state.first_possible_order_time}
                order_time_valid={this.state.valid_order_time}
								onOrderTypeChange={this.handleOrderTypeChange}
								orderTotal={this.orderTotal()}
								delivery_distance={this.state.delivery_distance}
                deliver_warning={this.state.delivery_warning}
              />
						</div>
						<div className="col-12 col-lg-5">
							<OrderDetail
								addMenu={this.addMenu}
								removeMenu={this.removeMenu}
								removeMenus={this.removeMenus}
								getMenu={this.getMenu}
								cart={this.state.cart}
								order_type={this.state.order_type}
								order_total={this.orderTotal()}
								order_min_amount={this.state.order_min_amount}
								order_date={this.state.order_date}
								order_time={this.state.order_time}
							/>
							<PaymentDetail
								cart={this.state.cart}
								order_type={this.state.order_type}
								order_total={this.orderTotal}
								order_sales_tax={this.salesTax}
								delivery_distance={this.state.delivery_distance}
								delivery_fee={this.state.delivery_fee}
								total_fees={this.totalFees}
							/>
						</div>
					</div>
				</div>
				<div className="row form-group-action cart-btn-group">
					<div className="col-12 col-md-6 push-md-6 cart-btn-wrap text-md-right">
						<button onClick={this.submitOrder} className="btn btn-primary cart-btn" id="payment_button">Pay with credit card</button>
					</div>
					<div className="col-12 col-md-6 pull-md-6 cart-btn-wrap">
						<a href={this.state.chef.chef_page} className="btn btn-white cart-btn">Back to menu</a>
					</div>
				</div>
				<NotificationSystem ref="notificationSystem" />

        <div className="modal" id="minOrderAlert" tabIndex="-1" role="dialog" aria-labelledby="minimumOrderAmount" aria-hidden="true">
          <div className="modal-dialog" role="document">
            <div className="modal-content">
              <div className="modal-header">
                <h4 className="text-center">Minimum order amount</h4>
                <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div className="modal-body justify-content-center ">

                <hr/>
                <p className="text-secondary">Sorry! You haven't hit chef {this.state.chef.first_name}'s' minimum of ${this.state.order_min_amount}, please add another item to the cart to hit the minimum and continue.</p>
                <hr/>

                <a href="#" className="btn btn-primary mb-2 btn-block" onClick={this.showMinOrderAlert}>OK</a>
              </div>
            </div>
          </div>
        </div>

			</div>
		)
	}
}

function mapStateToProps(state) {
	return {
		cart: state.cart,
		chef_location: window.cart_chef_location,
		menus: window.cart_menu_info
	}
}

function mapDispatchToProps(dispatch) {
	return {
		actions: bindActionCreators(CheckoutActions, dispatch)
	}
}

export default connect(
	mapStateToProps,
	mapDispatchToProps
)(App)
