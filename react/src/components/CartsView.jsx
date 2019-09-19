import React from "react";
import _ from "lodash";
import HttpService from "../http_service";

class CartsView extends React.Component {
	constructor(props) {
		super(props);

		const chef_info = window.get_cart_chef_info();

		this.state = {
			total_items_count: window.total_cart_items(),
			current_chef_id: window.get_cart_chef_id(),
			max_delivery_distance: chef_info.max_delivery_distance,
			cart_items: window.getCartItems(),
			check_disabled: false,

			show_edit_modal: false, // true -> modal is opened
			current_menu_data: null, // most recent edit modal data
			current_menu_id: null,
			current_cart_item_id: null,
			current_cart_item_data: null,
		};

		this.handleAddingCart = this.handleAddingCart.bind(this);
		this.incrementMenu = this.incrementMenu.bind(this);
		this.decrementMenu = this.decrementMenu.bind(this);
		this.removeMenu = this.removeMenu.bind(this);
		this.updateMenuCount = this.updateMenuCount.bind(this); // update Add To Cart Text on the button
		this.checkoutClicked = this.checkoutClicked.bind(this);
		this.editCartItem = this.editCartItem.bind(this);
		this.closeEditModal = this.closeEditModal.bind(this);
		this.incrementMenuItem = this.incrementMenuItem.bind(this);
		this.decrementMenuItem = this.decrementMenuItem.bind(this);
		this.handleSpecialChange = this.handleSpecialChange.bind(this);
		this.handleAddOnChange = this.handleAddOnChange.bind(this);
		this.saveEditModalChange = this.saveEditModalChange.bind(this);
		this.handleChangeMenuItemCount = this.handleChangeMenuItemCount.bind(this);
		this.handleChangeMenuCount = this.handleChangeMenuCount.bind(this);
	}

	componentDidMount() {
		window.addEventListener("cart_add", this.handleAddingCart);
	}

	componentWillMount() {}

	componentDidUpdate() {}

	editCartItem(menu_id, cart_item_id) {
		let menu_data = this.state.current_menu_data;
		// let cart_item = Object.assign({}, this.state.cart_items[cart_item_id])
		let cart_item = JSON.parse(JSON.stringify(this.state.cart_items[cart_item_id]));
		console.log("--> edit clicked", menu_id, cart_item_id, this.state.current_menu_id);
		console.log(cart_item);
		if (parseInt(this.state.current_menu_id, 10) !== parseInt(menu_id, 10)) {
			// Need to fetch data
			HttpService.get("/api/menus/" + menu_id).then(json => {
				console.log("===> fetch menu data", json);
				menu_data = json;
				this.setState({
					show_edit_modal: true,
					current_menu_id: menu_id,
					current_menu_data: menu_data,
					current_cart_item_id: cart_item_id,
					current_cart_item_data: cart_item,
				});
			});
		} else {
			this.setState({
				show_edit_modal: true,
				current_cart_item_id: cart_item_id,
				current_cart_item_data: cart_item,
			});
		}
	}
	closeEditModal() {
		this.setState({ show_edit_modal: false });
	}

	handleAddingCart(event) {
		console.log("---> react handleAddingCart", event);
		// e, chef_id, menu_id, menu_name, menu_img, max_delivery_distance, total, total_menus_count, special_instructions, addon_counts, menu_items_counts
		const {
			chef_id,
			menu_id,
			menu_name,
			menu_img,
			max_delivery_distance,
			total,
			total_menus_count,
			special_instructions,
			addon_counts,
			menu_items_counts,
			addon_info,
			menu_items_info,
		} = event.detail;

		if (this.state.current_chef_id && this.state.current_chef_id !== chef_id) {
			$("#orderFromMultipleChefs").modal("show");
		} else {
			this.state.current_chef_id = chef_id;
			this.state.max_delivery_distance = max_delivery_distance;

			// menu_id has to be string
			const cart_item = {
				chef_id: parseInt(chef_id),
				menu_id: menu_id,
				menu_name: menu_name,
				menu_img: menu_img,
				max_delivery_distance: parseFloat(max_delivery_distance),
				total: total,
				total_menus_count: total_menus_count,
				special_instructions: special_instructions,
				addon_counts: addon_counts,
				menu_items_counts: menu_items_counts,
				addon_info: addon_info,
				menu_items_info: menu_items_info,
			};

			this.addMenuItem(cart_item, true);
		}
	}

	addMenuItem(menu_item, should_update = false) {
		let current_cart_items = this.state.cart_items;
		let current_total_items_count = this.state.total_items_count;

		current_cart_items.push(menu_item);
		console.log("--> total count is being updated", current_total_items_count);
		current_total_items_count += parseInt(menu_item.total_menus_count, 10);
		console.log("--> total count is updated", current_total_items_count);

		if (should_update) {
			window.add_cart_menu(menu_item);
		}

		console.log("updating state..............");
		this.setState({
			cart_items: current_cart_items,
			total_items_count: current_total_items_count,
		});
	}

	removeMenuItem(menu_id) {
		let current_cart_items = Object.assign({}, this.state.cart_items);
		let current_items_count = this.state.total_items_count;
		let current_chef_id = this.state.current_chef_id;

		let menus = current_cart_items[menu_id];
		const idx = _.findIndex(menus, { menu_id: menu_id });

		if (idx > -1) {
			_.pullAt(menus, [idx]);

			if (menus.length == 0) {
				current_chef_id = null;
				delete current_cart_items[menu_id];
			} else {
				current_cart_items[menu_id] = menus;
			}

			current_items_count -= 1;

			this.setState({
				current_chef_id: current_chef_id,
				total_items_count: current_items_count,
				cart_items: current_cart_items,
			});

			console.log(this.state.cart_items);

			window.remove_cart_menu(menu_id);
		}
	}

	checkoutClicked() {
		var now = new Date();
		now.setTime(now.getTime() + 1 * 1800 * 1000); // Expires in 30 minutes
		window.document.cookie = "cart_chef_id=" + this.state.current_chef_id;
		window.document.cookie = "cart_id=" + window.cart_id;
		window.document.cookie = "expires=" + now.toUTCString() + "; path=/";

		window.location.href = `/cart/${window.cart_id}/${window.get_cart_chef_id()}`;
	}

	subTotal(menu_items) {
		if (menu_items.length > 0) {
			let first_menu = menu_items[0];
			let menu_total = {
				menu_id: first_menu.menu_id,
				menu_name: first_menu.menu_name,
				amount: 0,
				sub_total: 0.0,
			};

			for (let item of menu_items) {
				menu_total.amount += item.amount;
				menu_total.sub_total += item.amount * item.unit_price;
			}

			return menu_total.toFixed(2);
		} else {
			return 0.0;
		}
	}

	totalPrice() {
		let total_price = 0.0;
		this.state.cart_items.forEach(cart_item => {
			total_price += parseFloat(cart_item.total);
		});
		if (isNaN(total_price)) {
			total_price = 0.0;
		}

		if (total_price === 0.0) {
			console.log("TODO: disable checkout button");
		}
		return total_price.toFixed(2);
	}

	updateMenuCount(menu_id) {
		let amount = window.menu_cart_items(menu_id);
		if (amount > 0) $("#card-btn-" + menu_id).html("Add To Cart (" + amount + ")");
		else $("#card-btn-" + menu_id).html("Add To Cart");
	}

	saveEditModalChange() {
		// current_cart_item_id: cart_item_id,
		// current_cart_item_data: cart_item,
		if (
			parseInt(this.state.current_cart_item_data.total_menus_count, 10) <
			parseInt(this.state.current_menu_data.min_order_amount, 10)
		) {
			$(".add-to-cart-button").notify(
				"Order amount must be a minimum of (" + this.state.current_menu_data.min_order_amount + ")",
				{ className: "error", position: "top", autoHideDelay: 5000 }
			);
		} else {
			let cart_items = this.state.cart_items;
			let total_items_count =
				parseInt(this.state.total_items_count, 10) -
				parseInt(cart_items[this.state.current_cart_item_id].total_menus_count, 10);
			cart_items[this.state.current_cart_item_id] = this.state.current_cart_item_data;

			this.setState({
				show_edit_modal: false,
				total_items_count:
					total_items_count + parseInt(this.state.current_cart_item_data.total_menus_count, 10),
				cart_items: cart_items,
			});
			// Also should update Lockr
			window.update_cart_menu(this.state.current_cart_item_id, this.state.current_cart_item_data);
			this.updateMenuCount(this.state.current_menu_data.id);
		}
	}
	incrementMenuItem(menu_item_index) {
		let cart_item = this.state.current_cart_item_data;
		let selected_menu_item = this.state.current_menu_data.menu_items.find(e => e.id === menu_item_index);
		cart_item.menu_items_counts[menu_item_index] = parseInt(cart_item.menu_items_counts[menu_item_index], 10) + 1;
		cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) + 1;
		cart_item.total = parseFloat(cart_item.total) + parseFloat(selected_menu_item.price);
		cart_item.total = cart_item.total.toFixed(2);
		this.setState({ current_cart_item_data: cart_item });
	}

	decrementMenuItem(menu_item_index) {
		let cart_item = this.state.current_cart_item_data;
		let selected_menu_item = this.state.current_menu_data.menu_items.find(e => e.id === menu_item_index);
		if (parseInt(cart_item.menu_items_counts[menu_item_index], 10) > 0) {
			cart_item.menu_items_counts[menu_item_index] =
				parseInt(cart_item.menu_items_counts[menu_item_index], 10) - 1;
			cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) - 1;
			cart_item.total = parseFloat(cart_item.total) - parseFloat(selected_menu_item.price);
			cart_item.total = cart_item.total.toFixed(2);
			this.setState({ current_cart_item_data: cart_item });
		}
	}
	handleChangeMenuItemCount(input_ref, menu_item_index) {
		let new_value = parseInt(input_ref.value.replace(/[^0-9]/g, ""), 10) || 0;
		let cart_item = this.state.current_cart_item_data;
		let selected_menu_item = this.state.current_menu_data.menu_items.find(e => e.id === menu_item_index);
		let diff = new_value - parseInt(cart_item.menu_items_counts[menu_item_index], 10);
		cart_item.menu_items_counts[menu_item_index] =
			parseInt(cart_item.menu_items_counts[menu_item_index], 10) + diff;
		cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) + diff;
		cart_item.total = parseFloat(cart_item.total) + parseFloat(selected_menu_item.price) * diff;
		cart_item.total = cart_item.total.toFixed(2);
		this.setState({ current_cart_item_data: cart_item });
	}

	incrementMenu() {
		let cart_item = this.state.current_cart_item_data;
		cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) + 1;
		cart_item.total = parseFloat(cart_item.total) + parseFloat(this.state.current_menu_data.price);
		cart_item.total = cart_item.total.toFixed(2);
		this.setState({ current_cart_item_data: cart_item });
	}

	decrementMenu() {
		let cart_item = this.state.current_cart_item_data;
		if (parseInt(cart_item.total_menus_count, 10) > 0) {
			cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) - 1;
			cart_item.total = parseFloat(cart_item.total) - parseFloat(this.state.current_menu_data.price);
			cart_item.total = cart_item.total.toFixed(2);
			this.setState({ current_cart_item_data: cart_item });
		}
	}

	handleChangeMenuCount(input_ref) {
		let new_value = parseInt(input_ref.value.replace(/[^0-9]/g, ""), 10) || 0;
		let cart_item = this.state.current_cart_item_data;
		let diff = new_value - parseInt(cart_item.total_menus_count, 10);
		cart_item.total_menus_count = parseInt(cart_item.total_menus_count, 10) + diff;
		cart_item.total = parseFloat(cart_item.total) + parseFloat(this.state.current_menu_data.price) * diff;
		cart_item.total = cart_item.total.toFixed(2);
    this.setState({ current_cart_item_data: cart_item });
	}

	handleSpecialChange(e) {
		let cart_item = this.state.current_cart_item_data;
		cart_item.special_instructions = e.target.value;
		this.setState({ current_cart_item_data: cart_item });
	}

	handleAddOnChange(addon_index) {
		// this.state.current_cart_item_data.addon_counts[index],
		console.log("--> addon change");
		let cart_item = this.state.current_cart_item_data;
		// need to find addon price
		let selected_addon = this.state.current_menu_data.addons.find(addon => addon.id === parseInt(addon_index, 10));
		console.log("--> selected addon", selected_addon);
		if (parseInt(cart_item.addon_counts[addon_index], 10) === 0) {
			// It will be checked
			cart_item.addon_counts[addon_index] = 1;
			cart_item.total = parseFloat(cart_item.total) + parseFloat(selected_addon.price);
			cart_item.total = cart_item.total.toFixed(2);
		} else {
			cart_item.addon_counts[addon_index] = 0;
			cart_item.total = parseFloat(cart_item.total) - parseFloat(selected_addon.price);
			cart_item.total = cart_item.total.toFixed(2);
		}
		this.setState({ current_cart_item_data: cart_item });
	}

	removeMenu(e) {
		e.stopPropagation();
		const menu_id = e.target.dataset.menu_id;
		const cart_item_id = e.target.dataset.cart_item_id;
		let current_cart_items = this.state.cart_items;
		let current_total_items_count = this.state.total_items_count;
		const removing_count = parseInt(current_cart_items[cart_item_id].total_menus_count, 10);
		if (removing_count > 0) {
			current_cart_items.splice(cart_item_id, 1);
			window.remove_cart_menu(cart_item_id);
			this.setState({
				current_chef_id: window.get_cart_chef_id(),
				total_items_count: current_total_items_count - removing_count,
				cart_items: current_cart_items,
			});
			this.updateMenuCount(menu_id);
		} else {
			console.log("can not find menu to delete: ", cart_item_id);
		}
	}

	render_total_cart_item_count() {
		if (this.state.total_items_count > 0) {
			return (
				<div className="cart-nr-circle">
					{this.state.total_items_count}
				</div>
			);
		}
	}

	render_order_selection(menu_items_count, menu_items_info, cart_item_id) {
		// cart_item_id -> determine index in the Lockr.cart_items. Used for key
		let order_selections = [];
		for (let key in menu_items_count) {
			let count = parseInt(menu_items_count[key], 10);
			if (count > 0) {
				order_selections.push(
					<div key={"order_selections:" + cart_item_id + ":" + key} className="product-item--order-selection">
						<div className="order-selection-name">
							<span className="red-amount">
								{count}&nbsp;
							</span>
							{menu_items_info[key].name}
						</div>
						<span style={{ color: "red" }}>
							(${(parseFloat(menu_items_info[key].price) * count).toFixed(2)})
						</span>
					</div>
				);
			}
		}
		if (order_selections.length > 0) {
			order_selections.unshift(
				<div key={cart_item_id} className="product-separator">
					Order Selections:
				</div>
			);
		}
		return order_selections;
	}

	render_addons(addon_counts, addon_info, cart_item_id) {
		let addons = [];
		for (let key in addon_counts) {
			let count = parseInt(addon_counts[key], 10);
			if (count > 0) {
				addons.push(
					<div key={"addons:" + cart_item_id + ":" + key} className="product-item--addon">
						<div className="addon-name">
							{addon_info[key].name}
						</div>
						<span style={{ color: "red" }}>
							(${(parseFloat(addon_info[key].price) * count).toFixed(2)})
						</span>
					</div>
				);
			}
		}
		if (addons.length > 0) {
			addons.unshift(
				<div key={"addon_separator:" + cart_item_id} className="product-separator">
					Add ons:
				</div>
			);
		}
		return addons;
	}

	render_cart_items() {
		console.log("---> rendering cart items", this.state.cart_items);
		let cart_items = [];
		if (this.state.total_items_count > 0) {
			this.state.cart_items.forEach((menu, index) => {
				cart_items.push(
					<div
						onClick={() => this.editCartItem(menu.menu_id, index)}
						className="product-item"
						key={cart_items.length}
					>
						<div className="qty">
							<h6 className="title" style={{ float: "left" }}>
								<span className="red-amount">{menu.total_menus_count}</span> {menu.menu_name}
							</h6>
							<div className="price red">
								${menu.total}
							</div>
						</div>
						{this.render_order_selection(menu.menu_items_counts, menu.menu_items_info, index)}
						{this.render_addons(menu.addon_counts, menu.addon_info, index)}
						{menu.special_instructions &&
							<div className="other-info">
								<h6 style={{ marginBottom: 0, fontWeight: "bold" }}>Special Instructions:</h6>
								<div className="items" style={{ paddingLeft: "10px" }}>
									<div className="item border-bottom">
										<div className="title">
											{menu.special_instructions}
										</div>
									</div>
								</div>
							</div>}
						<div className="clearfix" style={{ marginBottom: "6px" }} />
						<div className="qty">
							<img src={menu.menu_img} alt="" className="product-img" />
							<div className="remove">
								<button
									data-cart_item_id={index}
									data-menu_id={menu.menu_id}
									className="btn btn-link btn-sm btn-remove btn-show"
									onClick={this.removeMenu}
									type="button"
								>
									<img
										data-cart_item_id={index}
										data-menu_id={menu.menu_id}
										src="/images/icons/remove.png"
										srcSet="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x"
										alt="Remove"
									/>
								</button>
							</div>
						</div>
					</div>
				);
			});
		}
		return cart_items;
	}

	render_cart_view() {
		if (this.state.total_items_count > 0) {
			// checks if it's chef shot page or not
			var navbar = document.getElementById("filtersNav");
			if (navbar) {
				return (
					<div>
						<a
							className="nav-link dropdown-toggle cart-icon"
							href="#"
							aria-expanded="true"
							onClick={() => {
								$("#floating-cart").toggleClass("active");
								if ($("#floating-cart").hasClass("active")) {
									$("#cart-details").html("Less");
									$("#floating-cart").find(".content").animate({ width: "toggle" }, 51, function() {
										$("#floating-cart").find(".content *").css("opacity", 1);
									});
									$("#floating-cart").addClass("shadow-left");
								} else {
									$("#floating-cart").removeClass("shadow-left");
									$("#cart-details").html("Details");
									$("#floating-cart").find(".content").animate({ width: "toggle" }, 10, function() {
										$("#floating-cart").find(".content *").css("opacity", 0);
									});
								}

								if (window.innerWidth <= 768) {
									if ($("#floating-cart").hasClass("active")) {
										$(document.body).css("overflow", "hidden");
									} else {
										$(document.body).css("overflow", "auto");
									}
								}
							}}
						>
							My Cart
						</a>
						{this.render_total_cart_item_count()}
					</div>
				);
			}
			return (
				<div>
					<a
						className="nav-link dropdown-toggle cart-icon"
						href="#"
						data-toggle="dropdown"
						aria-expanded="true"
					>
						My Cart
					</a>
					{this.render_total_cart_item_count()}
					<div className="dropdown-menu dropdown-menu-right cart-dropdown-menu mt-md-2">
						<div className="table cart-dropdown-table">
							{this.render_cart_items()}
						</div>
						<div className="d-flex align-items-center justify-content-between">
							<strong>
								Total:
								<span className="text-primary">${this.totalPrice()}</span>
							</strong>
							<a
								className="btn btn-primary btn-sm"
								disabled={this.state.check_disabled}
								onClick={this.checkoutClicked}
							>
								CHECKOUT
							</a>
						</div>
					</div>
				</div>
			);
		} else {
			// console.log("no item. not rendering")
		}
	}

	render_empty_cart_view() {
		if (this.state.total_items_count == 0) {
			return (
				<div>
					<a
						className="nav-link dropdown-toggle cart-icon"
						href="#"
						data-toggle="dropdown"
						aria-expanded="true"
					>
						My Cart
					</a>
					{this.render_total_cart_item_count()}
					<div className="dropdown-menu dropdown-menu-right cart-dropdown-menu mt-md-2">
						<div className="empty-cart">
							<img src="/images/empty_cart_smalljb.png" alt="" />
							<h3 className="pt-100">YOUR CART!</h3>
							<p>Your cart is currently empty.</p>
							<a href="" className="btn btn-primary">
								START ADDING YOUR FAVOURITE DISHES
							</a>
						</div>
					</div>
				</div>
			);
		}
	}

	render_floating_cart_view() {
		return (
			<div className={`floating-cart ${window.innerWidth > 768 ? "active" : ""}`} id="floating-cart">
				<div className="summary">
					<h5>
						<span className="cart-icon" /> My cart (<span className="red">{this.state.total_items_count}</span>)
					</h5>
					<div className="buttons">
						<button className="btn-details" id="cart-details">
							Details
						</button>
						<button
							className="checkout"
							disabled={this.state.check_disabled}
							onClick={this.checkoutClicked}
						>
							Checkout
						</button>
					</div>
				</div>
				<div className="content">
					{this.render_cart_items()}
					{this.state.total_items_count > 0 &&
						<div className="total">
							= ${this.totalPrice()}
						</div>}
					{this.state.total_items_count === 0 &&
						// render empty cart design
						<div className="floating-empty-cart">
							You haven't added anything yet.
							<img src="/images/empty_cart_jb_gray.png" alt="" />
							Start adding items from the menu to create your order.
						</div>}
					{/* <div className="clearfix"></div>
			    <div className="checkout">
			      <button className="btn btn-primary" disabled={this.state.check_disabled} onClick={this.checkoutClicked}>Checkout</button>
			    </div> */}
				</div>
			</div>
		);
	}

	render_edit_modal(menu) {
		console.log("---> rendering edit modal", menu, this.state.current_menu_data);
		return (
			<div
				id="cart_edit_modal"
				className="modal welcome-modal show addToCartModal"
				tabIndex="-1"
				role="dialog"
				style={{ display: "block", backgroundColor: "rgba(0, 0, 0, 0.5)", overflowY: "auto" }}
			>
				<div className="modal-dialog modal-lg" role="document">
					<div className="modal-content">
						<div className="modal-header justify-content">
							<h2 className="modal-title">
								{menu.name}
							</h2>
							<button
								type="button"
								className="close"
								data-dismiss="modal"
								aria-label="Close"
								onClick={this.closeEditModal}
							>
								<span aria-hidden="true">×</span>
							</button>
						</div>
						<div className="modal-body justify-content-center text-center">
							<p className="subtitle">
								{menu.description}
							</p>
							<h4 className="selection">Order Selection</h4>
							<p className="subtitle">
								Make your order selections below (min order of {menu.min_order_amount})
							</p>
							{menu.menu_type === "package" &&
								<div className="items">
									{menu.menu_items.map((item, index) =>
										<div className="item border-bottom" key={item.name + index}>
											<div className="title">
												{item.name}
											</div>
											<div className="quantity js-quantity">
												<button
													type="button"
													onClick={() => this.decrementMenuItem(item.id)}
													className="quantity__btn quantity__btn--dec js-quantity-minus"
												>
													–
												</button>
												<input
													type="text"
													className="quantity__input"
													onChange={e => this.handleChangeMenuItemCount(e.target, item.id)}
													value={
														this.state.current_cart_item_data.menu_items_counts[item.id]
													}
												/>
												<button
													type="button"
													onClick={() => this.incrementMenuItem(item.id)}
													className="quantity__btn quantity__btn--inc js-quantity-plus"
												>
													+
												</button>
											</div>
										</div>
									)}
								</div>}
							{menu.menu_type === "single" &&
								<div className="item border-bottom">
									<div className="title" />
									<div className="quantity js-quantity">
										<button
											type="button"
											onClick={this.decrementMenu}
											className="quantity__btn quantity__btn--dec js-quantity-minus"
										>
											–
										</button>
										<input
											type="text"
											className="quantity__input"
											onChange={e => this.handleChangeMenuCount(e.target)}
											value={this.state.current_cart_item_data.total_menus_count}
										/>
										<button
											type="button"
											onClick={this.incrementMenu}
											className="quantity__btn quantity__btn--inc js-quantity-plus"
										>
											+
										</button>
									</div>
								</div>}
							<h4 className="selection">Add Ons</h4>
							<p className="subtitle">Choose as many as you'd like</p>
							<div className="items">
								{menu.addons.map((item, index) =>
									<div className="item border-bottom" key={item.name + index}>
										<label
											className="custom-control custom-checkbox"
											onClick={() => this.handleAddOnChange(item.id)}
										>
											<div className="title">
												{item.name}&nbsp;- add ${parseFloat(item.price).toFixed(2)}
											</div>
											<input
												type="checkbox"
												checked={
													parseInt(
														this.state.current_cart_item_data.addon_counts[item.id],
														10
													) === 1 || false
												}
												onChange={() => this.handleAddOnChange(item.id)}
												className="custom-control-input"
											/>
											<span className="custom-control-indicator" />
										</label>
									</div>
								)}
							</div>
							<div className="items">
								<h4 className="selection"> Special Instructions </h4>
								<textarea
									className="form-control"
									rows="4"
									value={this.state.current_cart_item_data.special_instructions}
									onChange={this.handleSpecialChange}
								/>
							</div>
							<div className="add-btn">
								<button
									type="button"
									className="btn btn-primary add-to-cart-button btn-visible"
									data-total={this.state.current_cart_item_data.total}
									onClick={this.saveEditModalChange}
								>
									Save To Cart
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		);
	}

	render() {
		console.log("---> current menu data", this.state.show_edit_modal, this.state.current_menu_data);
		return (
			<div>
				{this.state.show_edit_modal && this.render_edit_modal(this.state.current_menu_data)}
				{this.render_cart_view()}
				{this.render_empty_cart_view()}
				{this.render_floating_cart_view()}
			</div>
		);
	}
}

export default CartsView;
