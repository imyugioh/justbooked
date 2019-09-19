import React from 'react'
import PromoCode from './PromoCode'
import '../../../styles/react_styles.css'

export default class DeliveryDetail extends React.Component {

	constructor(props) {
		super(props);

		this.changeFieldValue = this.changeFieldValue.bind(this)
		this.handleApplyCupon = this.handleApplyCupon.bind(this)
		this.ignoreChange = this.ignoreChange.bind(this)
		this.handleOrderOption = this.handleOrderOption.bind(this)

    this.order_type = 'delivery'
		this.email = ''
		this.first_name = ''
		this.last_name = ''

		if (window.cart_user_info) {
			this.email = window.cart_user_info.email
			this.first_name = window.cart_user_info.first_name
			this.last_name = window.cart_user_info.last_name
		}

	}

	componentDidMount() {

		// Date Picker
		const deliveryDatePicker = $('.js-order-date-picker');
		let notice_horus = this.props.chef.pre_order_notice_hour
		if (notice_horus == 0) {
			notice_horus = 24
		}

		if (deliveryDatePicker.length) {
			deliveryDatePicker.daterangepicker({
				singleDatePicker: true,
				opens: 'center',
				drops: 'bottom',
				showDropdowns: false,
				autoApply: true,
				autoUpdateInput: true,
				format: 'MM/DD/YYYY',
				minDate: moment().add(notice_horus, 'hours'),
				maxDate: moment().add(62, 'days'),
				locale: {
					cancelLabel: 'Clear'
				}
			})
		}

		$('.js-order-date-picker').on('apply.daterangepicker', (ev, picker) => {
			this.props.submit(ev.currentTarget.name, ev.currentTarget.value)
		})

		// Time picker
		const deliveryTimePicker = $('.js-order-time-picker')
		const that = this
		if (deliveryTimePicker.length) {
			deliveryTimePicker.pickatime({
				onSet: function (thingSet) {
					let value = document.getElementById('order_time').value
					that.props.submit("order_time", value)
				}
			})
		}

		// Default order type is delivery
		$(`#${this.order_type}`).click()
	}


	componentWillReceiveProps(nextProps) {
		if (nextProps.order_time_valid) {
			$('#order_time').removeClass("invalidInput")
		}
	}

	handleApplyCupon() {
		console.log("apply cupon")
	}

	handleOrderOption(e) {
    $(".btn-group > .btn").removeClass("active")
		$(e.target).addClass("active")
		this.props.submit('order_type', e.target.value)
    this.order_type = e.target.value

    this.props.onOrderTypeChange(this.order_type)

    if (this.order_type !== 'delivery') {
      $('#delivery_address').val('')
    }
	}

	changeFieldValue(e) {
		this.props.submit(e.target.name, e.target.value)
	}

	ignoreChange(e) {
		console.log("do nothing")
		// Do nothing
	}


	// deliveryDistance(lat, lng, address) {

	// 	console.log(">>>>>>>>>> target location: ", lat, ", ", lng, "  ", address)

	// 	let distance = 0
	// 	let directionsService = new google.maps.DirectionsService();

	// 	const request = {
	// 		origin: `${this.state.chef_lat}, ${this.state.chef_lng}`,
	// 		destination: `${lat}, ${lng}`,
	// 		waypoints: [],
	// 		optimizeWaypoints: true,
	// 		travelMode: 'DRIVING'
	// 	}

	// 	// console.log(request)

	// 	directionsService.route(request, (response, status) => {
	// 		if (status === 'OK') {
	// 			distance = response.routes[0].legs[0].distance.value / 1000
	// 			console.log("Distance: ", distance, " km")
	// 			this.setState({
	// 				delivery_distance: distance,
	// 				delivery_fee: this.deliveryFee(distance)
	// 			})
	// 		} else {
	// 			console.log("Can not calculate distance")
	// 		}
	// 	})

	// 	return distance
	// }


	orderTotal() {
		let total = 0.0

		for(let cart_item of this.props.cart) {
			let menu = this.props.getMenu(cart_item.menu_id)
			total += cart_item.quantity * menu.price
		}

		this.props.submit('order_total', total)
		return total
	}

	salesTax() {
		let tax = this.orderTotal() * 0.13
		this.props.submit('order_sales_tax', tax)
		return tax
	}

	subTotal() {
		let sub_total =this.orderTotal() + this.salesTax()
		this.props.submit('order_sub_total', sub_total)
		return sub_total
	}

	deliveryFee(distance) {
		let fee = 0
		if (this.subTotal() > 0) {
			const fee_per_km = 1.0;

			fee = distance * fee_per_km
		} else {
			fee = 0
			this.setState({delivery_fee: fee})
		}
		this.props.submit('order_delivery_fee', fee)
		return fee
	}

	totalFees() {
		// console.log("sub total: ", this.subTotal(), "  delivery fee: ", this.deliveryFee())
		let total_fees = this.subTotal() + this.state.delivery_fee
		this.props.submit('total_fees', total_fees)
		return total_fees
	}

  renderDeliveryWarning() {
    if (this.order_type === 'delivery' && this.props.deliver_warning && this.props.deliver_warning.length > 0) {
      return (
        <h5 className="text-primary" id="delivery_warning">{this.props.deliver_warning}</h5>
      )
    }
	}

	pickupOption() {
		let option = 'disabled'
		if (this.props.chef.pickup_available) {
			return (
				<button type="button" id='pickup' value='pickup' className="btn btn-secondary order_type" onClick={this.handleOrderOption}>Pickup</button>
			)
		} else {
			<button type="button" id='pickup' value='pickup' className="btn btn-secondary order_type" onClick={this.handleOrderOption} disable>Pickup</button>
		}
	}

	onsiteOption() {
		if (this.props.chef.onsite_cooking_available) {
			return (
				<button type="button" id='onsite-cooking' value='onsite-cooking' className="btn btn-secondary order_type" onClick={this.handleOrderOption}>Onsite Cooking</button>
			)
		} else {
			return (
				<button type="button" id='onsite-cooking' value='onsite-cooking' className="btn btn-secondary order_type" onClick={this.handleOrderOption} disabled>Onsite Cooking</button>
			)
		}
  }


  renderPickupAddressInfo() {
    if (this.order_type === 'pickup') {
      let chef = this.props.chef
      let chef_address_part1 = [chef.address1, chef.address2].join(' ')
      let chef_address = [chef_address_part1, chef.city, chef.state, chef.country, chef.zip_code].join(', ')
      return (
        <div className="form-group" id="pickup-address-info">
          <div className="form-group">
            <label htmlFor=""><strong>Pickup Information</strong></label><br/>
          </div>
          <div className="form-group">
            <label htmlFor="">Address: {chef_address}</label>
          </div>
          <div className="form-group">
            <label htmlFor="">Phone: {chef.phone}</label>
          </div>
        </div>
      )
    }
  }

  renderDelivery() {
    if (this.order_type === 'delivery') {
			let desc = []
			if (this.props.chef.pre_order_min_order_amount && this.props.chef.pre_order_min_order_amount > 0) {
				if (this.props.chef.free_delivery_min_order_amount > 0 && (this.props.orderTotal > this.props.chef.free_delivery_min_order_amount)) {
					desc.push(`Free Delivery (orders over $${this.props.chef.free_delivery_min_order_amount})`)
				} else {
					if (this.props.orderTotal < this.props.chef.pre_order_min_order_amount) {
						desc.push(`Minimum Order Amount: $${this.props.chef.pre_order_min_order_amount}`)
					}
          if (this.props.chef.delivery_fee) {
            desc.push(`Delivery fee: $${this.props.chef.delivery_fee}`)
          }
          if (this.props.chef.free_delivery_min_order_amount) {
            desc.push(`Free delivery on orders over $${this.props.chef.free_delivery_min_order_amount}`)
          }
				}
			}

			desc = desc.join(' | ')
			$('#delivery-address-form-group').show()

			let delivery_label = "Delivery address"
			if (this.props.delivery_distance) {
				delivery_label = delivery_label + ' (' + this.props.delivery_distance + ' km' + ')'
			}
			$('#delivery-address-label').html(delivery_label)


      return (
        <label htmlFor="description" className="text-primary" style={{display: 'block'}}>
          {desc}
        </label>
      )
    } else if (this.order_type === 'pickup') {
			$('#delivery-address-form-group').hide()
			if (this.props.orderTotal < this.props.chef.free_delivery_min_order_amount) {
				let desc = `Minimum Order Amount: $${this.props.chef.pre_order_min_order_amount}`
				return (
					<label htmlFor="description" className="text-primary" style={{display: 'block'}}>
						{desc}
					</label>
				)
			}
    } else if (this.order_type === 'onsite-cooking') {
      $('#delivery-address-form-group').show()
			$('#delivery-address-label').html("Onsite cooking address")
			if (this.props.orderTotal < this.props.chef.min_fee_for_onsite_cooking) {
				let desc = `Minimum Order Amount for onsite cooking is $${this.props.chef.min_fee_for_onsite_cooking}`
				return (
					<label htmlFor="description" className="text-primary" style={{display: 'block'}}>Minimum Order Amount For Onsite Cooking: ${this.props.chef.min_fee_for_onsite_cooking}</label>
				)
			}
    }
  }


  renderOrderTimeLabel() {
  	// console.log(this.props.order_time_valid);
    if (this.props.order_time_valid) {
      return (
        <label htmlFor="">Time</label>
      )
    } else {
      return (
        <label htmlFor=""><span className='text-primary'>Time (Any time after {this.props.possible_order_time})</span></label>
      )
    }
  }


	render() {
		return (
			<div className="delivery_detail">
			<div className="row">
				<div className="col-12 col-md-6">
					<div className="form-group">
						<label htmlFor="">Email address(
							<span className="small text-primary" data-toggle="tooltip" data-placement="top" title=""
										data-original-title="Please enter your primary email address here. We will use this email address to send you email notifications about your order.">Why do you need email?</span>)</label>
						<input type="email" id="order_email" name="email" onChange={this.changeFieldValue} className="form-control" placeholder="example@email.com" defaultValue={this.email}/>
					</div>
				</div>
				<div className="col-12 col-md-6">
					<div className="form-group">
						<label htmlFor="">Phone Number (
							<span className="small text-primary" data-toggle="tooltip" data-placement="top" title=""
										data-original-title="Please enter your mobile-phone number here. We will use this number to send you SMS/text notifications about your order.">Why we need your phone number?</span>)</label>
						<input type="text" id="order_delivery_phone_number" name="delivery_phone_number" onChange={this.changeFieldValue} className="form-control" placeholder="(000) 000-0000"/>
					</div>
				</div>
			</div>

			<div className="row">
				<div className="col-12 col-sm-6">
					<div className="form-group">
						<label htmlFor="">First name</label>
						<input type="text" id="order_first_name" name="first_name" onChange={this.changeFieldValue} className="form-control" placeholder="First name" defaultValue={this.first_name}/>
					</div>
				</div>
				<div className="col-12 col-sm-6">
					<div className="form-group">
						<label htmlFor="">Last name</label>
						<input type="text" id="order_last_name" name="last_name" onChange={this.changeFieldValue} className="form-control" placeholder="Last name" defaultValue={this.last_name}/>
					</div>
				</div>
			</div>


			<div className="row">
				<div className="col-12 col-sm-12">
					<div className="form-group">
						<label htmlFor="description" style={{display: 'block'}}>Order Option</label>
						<div className="form-group btn-group" role="group">
							<button type="button" id='delivery' value='delivery' className="btn btn-secondary order_type" onClick={this.handleOrderOption}>Delivery</button>
							{this.pickupOption()}
							{this.onsiteOption()}
						</div>
						{this.renderDelivery()}
					</div>
				</div>
			</div>


			<div className="row">
				<div className="col-12 col-sm-4">
					<div className="form-group">
						<label htmlFor="">Date</label>
						<input type="text" name="order_date"
									onChange={this.ignoreChange}
									 className="form-control newsletter-input newsletter-input--right newsletter-input--date js-order-date-picker"
									 placeholder={moment().format("MM/DD/YY")}/>
					</div>
				</div>
				<div className="col-12 col-sm-4">
					<div className="form-group">
            {this.renderOrderTimeLabel()}
						<input type="text" id="order_time" 
									onChange={this.ignoreChange}
									className="form-control js-order-time-picker picker__input"
									name="order_time" />
					</div>
				</div>
				<div className="col-12 col-sm-4">
					<div className="form-group" style={{visibility:'hidden'}}>
						<label htmlFor="">Filler</label>
						<input type="text" className="form-control" placeholder="e.g. 1 king st w."/>
					</div>
				</div>
			</div>

      {this.renderPickupAddressInfo()}

      <div className="form-group" id="delivery-address-form-group">
				<label htmlFor="" id="delivery-address-label">Delivery Address (*)</label>
        {this.renderDeliveryWarning()}
				<input type="text" id="delivery_address" name="delivery_address" onChange={this.changeFieldValue} className="form-control js-location-autocomplete" placeholder="e.g. 1 king st w." autoComplete="off"/>
			</div>


			<div className="form-group">
				<label htmlFor="description">More details</label>
				<textarea className="form-control" name="description" id="" cols="30" rows="5" name="delivery_more_detail" onChange={this.changeFieldValue}
									placeholder="Any extra instructions here... e.g. deliver to side door"></textarea>
			</div>

			<div className="row">
				<PromoCode/>
			</div>
		</div>
		)
	}
}




