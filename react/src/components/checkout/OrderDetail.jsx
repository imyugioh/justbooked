import React from 'react';
import { connect } from 'react-redux';
import '../../../styles/react_styles.css';

class OrderDetail extends React.Component {
	constructor(props, context) {
		super(props, context);
		this.state = {
			cart: this.props.cart,
		};
		this.incrementItem = this.incrementItem.bind(this);
		this.decrementItem = this.decrementItem.bind(this);
		this.removeItems = this.removeItems.bind(this);
		this.handleQuantityClick = this.handleQuantityClick.bind(this);
	}

	componentWillReceiveProps(nextProps) {
		this.setState({ cart: nextProps.cart });
	}

	incrementItem(e) {
		let menu_id = e.target.dataset.menu_id;
		this.props.addMenu(menu_id);
	}

	decrementItem(e) {
		let menu_id = e.target.dataset.menu_id;
		this.props.removeMenu(menu_id);
	}

	removeItems(e) {
		let menu_id = e.target.dataset.menu_id;
		this.props.removeMenus(menu_id);
	}

	handleQuantityClick(e) {
		// Do nothing
	}

	render_order_selection(menu_items_count, menu_items_info, cart_item_id) {
		// cart_item_id -> determine index in the Lockr.cart_items. Used for key
		let order_selections = [];
		for (let key in menu_items_count) {
			let count = parseInt(menu_items_count[key], 10);
			if (count > 0) {
				order_selections.push(
					<div key={'order_selections:' + cart_item_id + ':' + key} className="product-item--order-selection">
						<div className="order-selection-name">
							<span className="red-amount">
								{count}&nbsp;
							</span>
							{menu_items_info[key].name}
						</div>
						<span style={{ color: 'red' }}>
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
					<div key={'addons:' + cart_item_id + ':' + key} className="product-item--addon">
						<div className="addon-name">
							{addon_info[key].name}
						</div>
						<span style={{ color: 'red' }}>
							(${(parseFloat(addon_info[key].price) * count).toFixed(2)})
						</span>
					</div>
				);
			}
		}
		if (addons.length > 0) {
			addons.unshift(
				<div key={'addon_separator:' + cart_item_id} className="product-separator">
					Add ons:
				</div>
			);
		}
		return addons;
	}

	cartItem(menu, menu_key) {
		return (
			<div className="mb-2 order-item" key={menu_key}>
				<div className="order-card-border mb-3" />
				<div className="menu-title">
					<h6 className="title" style={{ margin: 0 }}>
						<span className="red-amount">{menu.total_menus_count}</span> {menu.menu_name}
					</h6>
					<div className="price red">
						${menu.total}
					</div>
				</div>
				{this.render_order_selection(menu.menu_items_counts, menu.menu_items_info, menu_key)}
				{this.render_addons(menu.addon_counts, menu.addon_info, menu_key)}
				{menu.special_instructions &&
					<div className="other-info">
						<div className="product-separator">Special Instructions:</div>
						<div className="items" style={{ paddingLeft: '10px' }}>
							<div className="item border-bottom">
								<div className="title">
									{menu.special_instructions}
								</div>
							</div>
						</div>
					</div>}
			</div>
		);
	}

	renderCartItems() {
		let cart_items = [];
		this.state.cart.forEach((menu, index) => {
			let item = this.cartItem(menu, index);
			cart_items.push(item);
		});
		return cart_items;
	}

	renderMinOrderAmount() {
		if (this.props.order_total < this.props.order_min_amount) {
			return (
				<h5 className="text-primary">
					Minimum order amount for {this.props.order_type} order is ${this.props.order_min_amount}
				</h5>
			);
		}
	}

	render() {
		return (
			<div className="block-grey order-detail">
				<h4 className="setting-page-title">Order Details</h4>
				{this.renderMinOrderAmount()}
				<div className="row mb-20">
					<div className="col-5 card-category-info">Date:</div>
					<div className="col-7 card-category-info">
						{this.props.order_date}
					</div>
				</div>
				<div className="row mb-3">
					<div className="col-5 card-category-info">Time:</div>
					<div className="col-7 card-category-info">
						{this.props.order_time}
					</div>
				</div>
				{this.renderCartItems()}
			</div>
		);
	}
}

OrderDetail = connect()(OrderDetail);

export default OrderDetail;
