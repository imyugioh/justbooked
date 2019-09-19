import React from 'react';
import ReactDOM from 'react-dom';
import { AppContainer } from 'react-hot-loader';
import Listings from './components/Listings';

const ListingApp = () => {
	return ReactDOM.render(
		<AppContainer>
			<Listings />
		</AppContainer>,
		document.getElementById('listing-app')
	);
};

export default ListingApp;
