import React from 'react';
import '../../../styles/react_styles.css';
import {connect} from "react-redux";

class PaymentDetail extends React.Component {

	constructor(props) {
		super(props);
	}

	renderDelivery() {
		if (this.props.order_type === 'delivery') {
			return (
				<div className="row mb-3" id="delivery_distance">
					<div className="col-8 card-category-info">Delivery fee:</div>
					<div className="col-4 card-category-info text-right">${this.props.delivery_fee.toFixed(2)}</div>
				</div>
			)
		}
	}

	render() {
		return (
			<div className="block-grey payment-detail">
				<h4 className="setting-page-title">Payment Details</h4>
				<div className="row mb-20">
					<div className="col-8 card-category-info">Order item(s) total :</div>
					<div className="col-4 card-category-info text-right">${this.props.order_total().toFixed(2)}</div>
				</div>
				{this.renderDelivery()}
        <div className="row mb-3">
          <div className="col-8 card-category-info">HST (13%):</div>
          <div className="col-4 card-category-info text-right">${this.props.order_sales_tax().toFixed(2)}</div>
        </div>
				<div className="order-card-border mb-3"></div>
				<div className="row">
					<div className="col-8 card-category-info">Total Fees:</div>
					<div className="col-4 card-category-info text-right">${this.props.total_fees().toFixed(2)}</div>
				</div>
				<script src="https://checkout.stripe.com/checkout.js" className="stripe-button"
					data-key="<%= Rails.configuration.stripe[:publishable_key] %>"
					data-description="A month's subscription"
					data-amount="500"
					data-locale="auto">
				</script>				
			</div>
		)
	}
}

PaymentDetail = connect()(PaymentDetail)

export default PaymentDetail
