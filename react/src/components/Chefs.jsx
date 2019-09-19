import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';

export default class Chefs extends React.Component {
	constructor(props) {
		super(props);
	}

	noDataContent() {
		return (
			<div className="row align-items-center justify-content-center ">
				<div className="col-12 col-md-auto sorry">
					<h3 className="mtb-50 mtb-sm-5 title-sorry text-center">
						We're sorry we couldn't find any results.
					</h3>
					<span>Search tips:</span>
					<ol>
						<li>Check that your address is correct.</li>
						<li>Try a more broad search term, e.g. instead of "chicken teriyaki", try "chicken".</li>
						<li>Need help? contact support@justbooked.com.</li>
					</ol>
				</div>
			</div>
		);
	}

	render() {
		return (
			<div className="container-fluid chefs-view show">
				{this.props.chefs.length === 0 && this.props.api_fetched && this.noDataContent()}
				<div className="row">
					<div className="col-md-10 offset-md-1 col-sm-12">
						{this.props.chefs.map(chef =>
							<a key={chef.id} href={chef.my_listings_path} className="restaurant-link">
								<div className="detail-card restaurant-view">
									<div className="media">
										<div className="media-start hidden-md-down">
											<img className="rounded" src={chef.profile_image_url} alt="" />
										</div>
										<div className="media-start hidden-lg-up">
											<img className="rounded img-mobile" src={chef.profile_image_url} alt="" />
										</div>
										<div className="media-body hidden-md-down">
											<div className="restaurant-info hidden-md-down flex-wid-40">
												<h5 className="mt-0 mb-0 card-title bold">
													{chef.first_name} {chef.last_name}
												</h5>
												<div className="card-text-description">
													<p>
														{chef.short_address}
													</p>
												</div>
												{chef.tag_names.length > 0 &&
													<div className="restaurant-category">
														{_.join(chef.tag_names, ', ')}
													</div>}
											</div>

											<div className="border hidden-md-down" />

											<div className="hidden-md-down border-right border-left">
												<p className="mt-0 mb-0 bold">
													{chef.pre_order_notice_hour} hour notice required
												</p>
											</div>

											<div className="border hidden-md-down" />

											<div className="hidden-md-down">
												<p className="mt-0 mb-0 bold">
													minimum ${parseFloat(chef.pre_order_min_order_amount).toFixed(2)}{' '}
													order
												</p>
											</div>
										</div>

										<div className="media-body hidden-lg-up">
											<div className=" mb-0">
												<h5 className="mt-0 mb-0 card-title bold">
													{chef.first_name} {chef.last_name}
												</h5>
												<div className="card-text-description">
													<p>
														{chef.short_address}
													</p>
												</div>
												<p className="mt-0 mb-0">
													{chef.pre_order_notice_hour} hour notice required
												</p>
												<p className="mt-0 mb-0">
													minimum ${parseFloat(chef.pre_order_min_order_amount).toFixed(2)}{' '}
													order
												</p>
											</div>
										</div>
									</div>
								</div>
							</a>
						)}
					</div>
				</div>
			</div>
		);
	}
}

Chefs.propTypes = {
	chefs: PropTypes.arrayOf(PropTypes.shape({})).isRequired,
};
