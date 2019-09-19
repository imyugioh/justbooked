import React from 'react';
import _ from 'lodash';
import '../../styles/react_styles.css';

const priceOptions = [
	{
		count: 0,
		title: 'Under $25',
		range: '0,25',
	},
	{
		count: 0,
		title: '$25 - $45',
		range: '26,45',
	},
	{
		count: 0,
		title: '$45 - $60',
		range: '45,60',
	},
	{
		count: 0,
		title: '$60+',
		range: '60,1000',
	},
];

export default class SearchFilter extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			cusine_types: [],
			dietary_types: [],
			price_filters: [],
			filter_rendered: false,
			menus: props.menus,
		};
	}

	componentWillReceiveProps(nextProps) {
		if (this.state.menus !== nextProps.menus && !this.state.filter_rendered) {
			this.setState(
				{
					menus: nextProps.menus,
					filter_rendered: true,
				},
				() => {
					this.buildFilters();
				}
			);
		}
	}

	buildFilters() {
		let cuisine_type_tag_names = [];
		let dietary_type_tag_names = [];
		_.each(this.state.menus, item => {
			cuisine_type_tag_names.push(item.cuisine_type_tag_names);
			dietary_type_tag_names.push(item.dietary_type_tag_names);
		});
		const dietaryResult = [];
		_.each(_.countBy(_.flattenDeep(dietary_type_tag_names)), (value, key) => {
			dietaryResult.push({ key, value });
		});
		this.setState({
			cusine_types: _.countBy(_.flattenDeep(cuisine_type_tag_names)),
			dietary_types: dietaryResult,
			price_filters: _.map(priceOptions, priceItem => {
				priceItem.count = _.filter(this.state.menus, menuItem => {
					const price = parseInt(menuItem.price);
					const priceRange = priceItem.range.split(',');
					return price >= parseInt(priceRange[0]) && price <= parseInt(priceRange[1]);
				}).length;
				return priceItem;
			}),
		});
	}

	componentDidMount() {
		this.buildFilters();
	}

	render() {
		const { data, onDietaryChange, onPriceChange, onCuisineChange } = this.props;
		return (
			<div className="container-fluid filters">
				<div className="row align-items-center justify-content-center justify-content-sm-between">
					<div className="col-12 col-md-auto filters-views">
						<div className="dropdown dropdown-filter-wrapper d-flex">
							<button
								className="btn btn-link btn-filter dropdown-toggle hidden-md-up"
								type="button"
								id="filtersButton"
								data-toggle="collapse"
								data-target="#filtersContainer"
								aria-haspopup="true"
								aria-expanded="false"
							>
								Filters
							</button>
						</div>
						<div className="d-flex view-switch hidden-md-up">
							<a href="#" className="active js-chefview">
								View Restaurants
							</a>
							&nbsp;&nbsp;&nbsp;
							<a href="#" className="js-listview">
								View Menus
							</a>
						</div>
					</div>
					<div className="col-12 col-md-auto">
						<div className="dropdown dropdown-filter-wrapper">
							<div className="collapse" id="filtersContainer">
								<ul className="nav flex-column flex-md-row">
									<li className="nav-item">
										<div className="dropdown">
											<button
												id="cuisine_type"
												className="btn btn-link btn-filter dropdown-toggle"
												type="button"
												data-toggle="dropdown"
												aria-haspopup="true"
												aria-expanded="false"
											>
												Cuisine Type
											</button>
											<div className="dropdown-menu" aria-labelledby="cuisine_type">
												<div onClick={e => onCuisineChange(e, null)}>
													<a
														href="#"
														className="dropdown-item"
														data-option-array-index="0"
													>{`All (${_.sum(Object.values(this.state.cusine_types))})`}</a>
												</div>
												{_.map(this.state.cusine_types, (cnt, key) => {
													return (
														<div
															key={key}
															onClick={e =>
																onCuisineChange(e, {
																	tag_ids: key,
																})}
														>
															<a className="dropdown-item">{`${key} (${cnt})`}</a>
														</div>
													);
												})}
											</div>
										</div>
									</li>
									<li className="nav-item">
										<div className="dropdown">
											<button
												id="price"
												className="btn btn-link btn-filter dropdown-toggle"
												type="button"
												data-toggle="dropdown"
												aria-haspopup="true"
												aria-expanded="false"
											>
												Price
											</button>
											<div className="dropdown-menu" aria-labelledby="price">
												<div className="form-check">
													<label className="form-check-label">
														<input
															type="checkbox"
															className="form-check-input"
															onChange={e => onPriceChange(e, 'all', 0, e.target.checked)}
															checked={data && _.indexOf(data.price_filter, 'all') !== -1}
														/>
														<span className="custom-control-description">{`All  (${_.sumBy(
															this.state.price_filters,
															'count'
														)})`}</span>
													</label>
												</div>
												{this.state.price_filters.map((price, i) => {
													return (
														price.count !== 0 &&
														<div className="form-check" key={i}>
															<label className="form-check-label">
																<input
																	type="checkbox"
																	className="form-check-input"
																	onChange={e =>
																		onPriceChange(
																			e,
																			price.range,
																			i + 1,
																			e.target.checked
																		)}
																	checked={
																		data &&
																		_.indexOf(data.price_filter, price.range) !== -1
																	}
																/>
																<span className="custom-control-description">{`${price.title} (${price.count})`}</span>
															</label>
														</div>
													);
												})}
											</div>
										</div>
									</li>
									<li className="nav-item">
										<div className="dropdown">
											<button
												id="dietary_preferences"
												className="btn btn-link btn-filter dropdown-toggle"
												type="button"
												data-toggle="dropdown"
												aria-haspopup="true"
												aria-expanded="false"
											>
												Dietary Preferences
											</button>
											<div className="dropdown-menu" aria-labelledby="dietary_preferences">
												<div className="form-check">
													<label className="form-check-label">
														<input
															type="checkbox"
															className="form-check-input"
															checked={data && _.indexOf(data.dietary_type, 'all') !== -1}
															onChange={e =>
																onDietaryChange(e, 'all', 0, e.target.checked)}
														/>
														<span className="custom-control-description">{`All (${_.sumBy(
															this.state.dietary_types,
															'value'
														)})`}</span>
													</label>
												</div>
												{this.state.dietary_types.map((item, i) => {
													return (
														<div className="form-check" key={i}>
															<label className="form-check-label">
																<input
																	type="checkbox"
																	className="form-check-input"
																	checked={
																		data &&
																		_.indexOf(data.dietary_type, item.key) !== -1
																	}
																	onChange={e =>
																		onDietaryChange(
																			e,
																			item.key,
																			i + 1,
																			e.target.checked
																		)}
																/>
																<span className="custom-control-description">{`${item.key} (${item.value})`}</span>
															</label>
														</div>
													);
												})}
											</div>
										</div>
									</li>
									{/* <li className="nav-item">
                    <div className="dropdown js-booking-date-parent">
                      <button id="booking_date" className="btn btn-link btn-filter dropdown-toggle" type="button">
                        Booking Date
                      </button>
                      <input type="hidden" id="booking_date" name="booking_date" className="js-daterangepicker" />
                    </div>
                  </li>
                  <li className="nav-item">
                    <div className="dropdown">
                      <button id="servings" className="btn btn-link btn-filter dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Servings
                      </button>
                      <div className="dropdown-menu px-3 py-3" aria-labelledby="servings">
                        <p className="text-nowrap">The number of servings</p>
                        <input className="js-bootstrap-slider" id="capacity" name="servings" type="text" />
                      </div>
                    </div>
                  </li> */}
								</ul>
							</div>
						</div>
					</div>
					<div className="col-12 col-md-auto">
						<ul className="nav listing-tabs justify-content-md-end">
							<li className="nav-item">
								<a
									className="nav-link active js-chefview"
									href="#"
									onClick={() => this.props.handleModeChange('restaurant')}
								>
									View Restaurants
								</a>
							</li>
							<li className="nav-item">
								<a
									className="nav-link js-listview"
									href="#"
									onClick={() => this.props.handleModeChange('menus')}
								>
									View Menus
								</a>
							</li>
							<li className="nav-item">
								<a
									className="nav-link js-mapview"
									href="#"
									onClick={() => this.props.handleModeChange('menus')}
								>
									View Map
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		);
	}
}
