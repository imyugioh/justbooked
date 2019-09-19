import React from 'react';
import '../../../styles/react_styles.css';
import {connect} from "react-redux";

class PromoCode extends React.Component {

	constructor(props) {
		super(props);

		this.state = {
		}
		this.handleApplyCupon = this.handleApplyCupon.bind(this);
	}

	handleApplyCupon() {
		console.log("apply cupon")
	}


	render() {
		return (
			<div className="col-12 col-md-7 mb-4">
				<label htmlFor="">Appy promo code</label>
				<div className="input-group mb-2">
					<input type="email" className="form-control" placeholder="Enter promo code" required=""/>
					<span className="input-group-btn">
								<button type="submit"
												className="btn btn-outline-primary btn-block text-uppercase apply-code-btn">Apply</button>
							</span>
				</div>
			</div>
		)
	}
}

PromoCode = connect()(PromoCode)

export default PromoCode
