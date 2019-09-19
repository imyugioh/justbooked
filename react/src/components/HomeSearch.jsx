import React from 'react';

export default class HomeSearch extends React.Component {
	constructor(props) {
		super(props);
		this.state = { qm: '', location: '' };

		this.onCurrentLocationClicked = this.onCurrentLocationClicked.bind(this);
		this.handleSearchClicked = this.handleSearchClicked.bind(this);
		this.handleLocationChange = this.handleLocationChange.bind(this);
		this.handleChange = this.handleChange.bind(this);
	}

	componentDidMount() {
		window.addEventListener('location_found', this.handleLocationChange);
	}

	handleLocationChange(e) {
		console.log('got handle location change');
	}

	onCurrentLocationClicked() {
		// console.log("Current location clicked");
	}

	handleSearchClicked(e) {
		e.preventDefault();

		let params = '';
		let location = '';

		if (this.state.qm) {
			params += encodeURI(`qm=${this.state.qm}`);
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

		if (params.length > 0) {
			window.location.href = `/listings?${params}`;
		} else {
			Lockr.set('search_location', {
				lat: 43.653226,
				lng: -79.38318429999998,
				address: 'Toronto, Ontario, Canada',
			});

			window.location.href =
				'/listings?qr=&qm=&location=Toronto,%20ON,%20Canada&lat=43.653226&lng=-79.38318429999998';
		}
	}

	handleChange(e) {
		this.setState({ [e.target.name]: e.target.value });
	}

	render() {
		return (
			<div className="row align-items-center">
				<div className="col">
					<h1 className="hero-title desktop-only">
						<span
							className="typer"
							data-words="Business,Office"
							data-colors="white"
							data-delay="150"
							data-deleteDelay="3000"
						/>
						&nbsp;catering made simple <br />
					</h1>
					<h1 className="hero-title mobile-only">
						<span
							className="typer"
							data-words="Business,Office"
							data-colors="white"
							data-delay="150"
							data-deleteDelay="3000"
						/>
						&nbsp;catering<br />made simple
					</h1>
					<h2 className="hero-title-h2">
						Order delicious food from your favourite chefs & caterers for your next event in advance.
					</h2>
					<form onSubmit={this.handleSearchClicked} className="hero-form" action="listing.html">
						<div className="hero-form__input-wrapper">
							<input
								type="text"
								onChange={this.handleChange}
								name="location"
								ref="google_location"
								value={this.state.location}
								className="form-control form-control-lg hero-form__input hero-form__input--location js-location-autocomplete"
								placeholder="Enter your address"
							/>
						</div>
						<button
							type="submit"
							className="btn btn-primary btn-lg hero-form__button hero-form__button--submit"
						>
							GO!
						</button>
						<span className="hero-form__input-text">or</span>
						<button
							type="button"
							onClick={this.onCurrentLocationClicked}
							className="btn btn-primary btn-lg hero-form__button hero-form__button--location js-detect-location"
						>
							Current Location
						</button>
					</form>
				</div>
			</div>
		);
	}
}
