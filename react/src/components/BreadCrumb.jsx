import React from 'react';
import ReactGoogleMapLoader from 'react-google-maps-loader';
import ReactGooglePlacesSuggest from 'react-google-places-suggest';
import '../../styles/react_styles.css';

export default class BreadCrumb extends React.Component {
	constructor(props) {
		super(props);

		this.state = {
			search: '',
			lat: '',
			lng: '',
			value: '',
			isShowing: false,
			qr: props.queryR,
			qm: props.queryM,
		};

		this.handleSearchTextChange = this.handleSearchTextChange.bind(this);
		this.handleSearch = this.handleSearch.bind(this);
	}

	// componentWillMount() {
	//   document.addEventListener('mousedown', this.handleClickOutside.bind(this))
	// }

	// componentWillUnMount() {
	//   document.removeEventListener('mousedown', this.handleClickOutside.bind(this))
	// }

	componentDidMount() {
		navigator.geolocation.getCurrentPosition(position => {
			this.setState({ lat: position.coords.latitude, lng: position.coords.longitude });
		});

		window.addEventListener('location_found', this.handleLocationChange);

		let searched_location = Lockr.get('search_location');
		if (searched_location) {
			// This is requried
			window.App.user_location.location = searched_location.address;
			window.App.user_location.lat = searched_location.lat;
			window.App.user_location.lng = searched_location.lng;

			$('.js-location-autocomplete').val(searched_location.address);
			$('.hero-breadcrumb--location').text(searched_location.address);
			$('.js-location-autocomplete').trigger('geocode');
		}
	}

	handleLocationChange(e) {
		if (e.target && e.target.style) {
			e.target.style.removeProperty('border');
		}
	}

	handleClickOutside(e) {
		if (this.container && !this.container.contains(e.target)) this.setState({ isShowing: false });
	}

	handleInputChange(e) {
		const v = `${e.target.value}, Ontario, Canada`;
		this.setState({ search: v, value: e.target.value });
	}

	// handleSelectSuggest(suggest) {
	//   this.setState({
	//     search: "",
	//     value: suggest.formatted_address,
	//     lat: suggest.geometry.location.lat(),
	//     lng: suggest.geometry.location.lng()
	//   })

	//   this.props.handleFetchSearchResult({
	//     lat: suggest.geometry.location.lat(),
	//     lng: suggest.geometry.location.lng()
	//   })
	// }

	handleSearchTextChange(e, keyword) {
		e.target.style.removeProperty('border');
		this.setState({ [keyword]: e.target.value });
	}

	handleSearch(e) {
		e.preventDefault();
		let go_ahead = true;

		if (!this.refs.google_location.value) {
			this.refs.google_location.style.borderWidth = '2px';
			this.refs.google_location.style.borderColor = 'red';
			go_ahead = false;
		}

		// let tag_query = document.getElementById('tag_query')
		// if (tag_query && tag_query.value.length == 0) {
		//   tag_query.style.borderWidth = '2px'
		//   tag_query.style.borderColor = 'red'
		// }

		if (go_ahead === false) {
			return false;
		}

		// this.refs.google_location.style.outline = 'none'
		// tag_query.style.outline = 'none'

		let params = '';
		let location = '';

		if (this.state.qr) {
			params += encodeURI(`qr=${this.state.qr}`);
		}

		if (this.state.qm) {
			params += encodeURI(`&qm=${this.state.qm}`);
		}

		if (this.props.mode === 'menus') {
			params += encodeURI(`&mode=${this.props.mode}`);
		}

		let geo_location = this.refs.google_location.value;
		if (!geo_location && window.App.user_location.location) {
			geo_location = window.App.user_location.location;
			params += encodeURI(`&location=${geo_location}`);
		} else {
			location = 'Toronto';
		}

		if (window.App.user_location.lat && window.App.user_location.lat) {
			params += `&lat=${window.App.user_location.lat}&lng=${window.App.user_location.lng}`;
		}

		// console.log(params)
		if (params.length > 0) {
			window.location.href = `/listings?${params}`;
		} else {
			window.location.href =
				'/listings?qr=&qm=&location=Toronto,%20ON,%20Canada&lat=43.653226&lng=-79.38318429999998';
		}
	}

	// handleCurrentPlace() {
	//   const {lat, lng} = this.state
	//   const self = this
	//   if(lat !== null && lng !== null) {
	//     const google_map_pos = new window.google.maps.LatLng(lat, lng)
	//     new window.google.maps.Geocoder().geocode({'latLng': google_map_pos, country: 'Canada'}, function(results){
	//       if(results[0]) {
	//         self.setState({
	//           value: results[0].formatted_address
	//         })
	//       }
	//     })
	//   }
	//   self.setState({isShowing: false})
	// }

	// showDropDown() {
	//   this.setState({
	//     isShowing: true
	//   })
	// }

	// hideDropDown() {
	//   this.setState({
	//     isShowing: false
	//   })
	// }

	render() {
		const { search, value, isShowing } = this.state;
		console.log('--> this state location: ', this.state.location);
		console.log('--> total state: ', this.state);
		return (
			<div className="submenu-wrapper">
				<div className="row no-gutters align-items-center justify-content-center justify-content-md-between submenu">
					<div className="col-12 col-md-auto">
						<nav className="breadcrumb">
							<a className="breadcrumb-item" href="/">
								Home
							</a>
							<span className="breadcrumb-item active hero-breadcrumb--location">
								{this.props.location}
							</span>
						</nav>
					</div>
					<div className="col-12 col-md-auto">
						<div className="location custom">
							<form className="hero-form mt-5px mr-15">
								<div className="hero-form__input-wrapper">
									{this.props.mode === 'menus' &&
										<input
											type="text"
											onChange={e => this.handleSearchTextChange(e, 'qm')}
											value={this.state.qm}
											id="tag_query"
											className="form-control form-control-lg hero-form__input hero-form__input--food h-50"
											placeholder="Lunch, Pasta, Sandwich...."
										/>}
									{(this.props.mode === 'restaurant' || this.props.mode === '') &&
										<input
											type="text"
											onChange={e => this.handleSearchTextChange(e, 'qr')}
											value={this.state.qr}
											id="restaurant_query"
											className="form-control form-control-lg hero-form__input hero-form__input--food hero-form__input--restaurant h-50"
											placeholder="Restaurant name or cuisine...."
										/>}
								</div>

								<div className="hero-form__input-wrapper">
									<div style={{ position: 'relative' }}>
										<div className="sc-ifAKCX cnyXj">
											<input
												type="text"
												onChange={this.handleLocationChange}
												name="location"
												ref="google_location"
												value={this.state.location}
												className="form-control form-control-lg hero-form__input hero-form__input--location h-50 hero-form__input--location js-location-autocomplete"
												placeholder="Enter address"
												autoComplete="off"
												name=""
											/>
										</div>
									</div>
								</div>

								<button
									onClick={this.handleSearch}
									className="btn btn-primary btn-lg hero-form__button hero-form__button--submit h-50"
								>
									UPDATE SEARCH
								</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		);
	}
}
