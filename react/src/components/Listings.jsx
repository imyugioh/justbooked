import React from 'react';
import _ from 'lodash';
import BreadCrumb from './BreadCrumb';
import SearchFilter from './SearchFilter';
import Menus from './Menus';
import Chefs from './Chefs';
import SearchStore from '../stores/search_store';
import Querystring from 'querystring';
import '../../styles/react_styles.css';

export default class Listigs extends React.Component {
	constructor(props) {
		super(props);
		const search = location.search.substring(1);
		const query = Querystring.parse(search);

		this.query = query;
		this.page = 0;

		this.state = {
			isLoading: false,
			location: query.location,
			api_data: {},
			api_fetched: false,
			menus: [],
			chefs: [],
			cusine_type: { tag_ids: ['all'] },
			dietary_type: ['all'],
			price_filter: ['all'],
			geoCode: { lat: null, lng: null },
			mode: this.query.mode || 'restaurant',
		}; // initial fetch // restaurant & menu view. restaurant view default.

		this.handleCuisineChange = this.handleCuisineChange.bind(this);
		this.handlePriceChange = this.handlePriceChange.bind(this);
		this.handleDietaryChange = this.handleDietaryChange.bind(this);
		this.handleModeChange = this.handleModeChange.bind(this);
		this.onFetchSearchResult = this.onFetchSearchResult.bind(this);
		this.onLoadMore = this.onLoadMore.bind(this);
	}

	componentDidMount() {
		this.setState({ isLoading: true });
		SearchStore.search(this.query);
		this.unsubscribe = SearchStore.listen(this.onFetchSearchResult);
	}

	onLoadMore(e) {
		e.preventDefault();
		// need to fetch more menus
		this.setState({ isLoading: true });
		let params = this.query;
		params.page = this.page + 1;
		SearchStore.search(params);
	}

	handleModeChange(newMode) {
		this.setState({ mode: newMode });
	}

	onFetchSearchResult(result) {
		this.page += 1;
		// check if it's initial fetch or ... load more
		if (this.state.api_fetched === false) {
			this.state.api_fetched = true;
			this.state.api_data = result;
		} else {
			this.state.api_data.menus = this.state.api_data.menus.concat(result.menus);
			this.state.api_data.chefs = _.uniqWith(this.state.api_data.chefs.concat(result.chefs), _.isEqual);
		}
		this.filterData();
	}

	handleCuisineChange(e, value) {
		console.log('--> handle cuisine change', e, value);
		this.state.cusine_type = value;
		this.filterData();
		$('#cuisine_type').click();
	}

	handlePriceChange(e, value, i, checked) {
		const priceFilter = this.state.price_filter;

		if (checked && value !== 'all') {
			priceFilter[i] = value;
			priceFilter[0] = '';
		} else if (checked && value === 'all') {
			priceFilter.splice(0, priceFilter.length);
			priceFilter[0] = 'all';
		} else {
			priceFilter[i] = '';

			if (_.compact(priceFilter).length === 0) {
				priceFilter.splice(0, priceFilter.length);
				priceFilter[0] = 'all';
			}
		}

		this.state.price_filter = priceFilter;
		this.filterData();
		$('#price').click();
	}

	handleDietaryChange(e, value, i, checked) {
		const dietaryType = this.state.dietary_type;

		if (checked && value !== 'all') {
			dietaryType[i] = value;
			dietaryType[0] = '';
		} else if (checked && value === 'all') {
			dietaryType.splice(0, dietaryType.length);
			dietaryType[0] = 'all';
		} else {
			dietaryType[i] = '';

			if (_.compact(dietaryType).length === 0) {
				dietaryType.splice(0, dietaryType.length);
				dietaryType[0] = 'all';
			}
		}

		this.state.dietary_type = dietaryType;
		this.filterData();
		$('#dietary_preferences').click();
	}

	filterData() {
		console.log('--> filtering', this.state.api_data);
		if (this.state.api_data && this.state.api_data.menus.length > 0) {
			let menus = this.state.api_data.menus;
			let filteredData = {};
			if (!!this.state.cusine_type || !!this.state.dietary_type.length || !!this.state.price_filter.length) {
				if (this.state.cusine_type && this.state.cusine_type.tag_ids[0] !== 'all') {
					menus = _.filter(menus, o => {
						return _.indexOf(o.cuisine_type_tag_names, this.state.cusine_type.tag_ids) !== -1;
					});
				}

				if (this.state.dietary_type.length && this.state.dietary_type[0] !== 'all') {
					let dietMenus = [];
					_.each(this.state.dietary_type, dietary_type_item => {
						let result = _.filter(menus, menu => {
							return dietary_type_item === 'all'
								? true
								: _.indexOf(menu.dietary_type_tag_names, dietary_type_item) !== -1;
						});
						if (result.length) {
							dietMenus = dietMenus.concat(result);
						} else {
							console.log('no result for ', dietary_type_item);
						}
					});
					menus = dietMenus.length && dietMenus;
				}

				if (this.state.price_filter.length && this.state.price_filter[0] !== 'all') {
					let priceMenus = [];
					_.each(this.state.price_filter, item => {
						if (item) {
							let priceRange = item.split(',');
							let result = _.filter(menus, o => {
								return (
									parseFloat(o.price) >= parseFloat(priceRange[0]) &&
									parseFloat(o.price) <= parseFloat(priceRange[1])
								);
							});
							if (result.length) priceMenus = priceMenus.concat(result);
						}
					});
					menus = priceMenus.length && priceMenus;
				}
			}
			this.setState({
				menus: menus,
				chefs: this.state.api_data.chefs,
				isLoading: false,
			});
		} else {
			this.setState({ isLoading: false, chefs: this.state.api_data.chefs });
		}
	}

	render() {
		console.log('rendering ---->', this.state.menus, this.state.chefs);
		return (
			<div className="listings">
				<BreadCrumb
					mode={this.state.mode}
					queryR={this.query.qr}
					queryM={this.query.qm}
					handleFetchSearchResult={this.onFetchSearchResult}
					location={this.state.location}
				/>
				<SearchFilter
					handleModeChange={this.handleModeChange}
					onDietaryChange={this.handleDietaryChange}
					onPriceChange={this.handlePriceChange}
					onCuisineChange={this.handleCuisineChange}
					menus={this.state.menus}
					data={this.state}
				/>
				<Chefs chefs={this.state.chefs} api_fetched={this.state.api_fetched} />
				<Menus menus={this.state.menus} api_fetched={this.state.api_fetched} />
				<div className="container-fluid" style={{ textAlign: 'center' }}>
					{this.state.menus.length > 0 &&
						(!this.state.isLoading
							? <a
									href="#"
									className="btn btn-outline-primary is-colored"
									onClick={this.onLoadMore}
									style={{ width: '30%', marginBottom: 30 }}
								>
									Load More
								</a>
							: <div className="sk-folding-cube">
									<div className="sk-cube1 sk-cube" />
									<div className="sk-cube2 sk-cube" />
									<div className="sk-cube4 sk-cube" />
									<div className="sk-cube3 sk-cube" />
								</div>)}
				</div>
			</div>
		);
	}
}
