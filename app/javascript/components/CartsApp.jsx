import React from 'react';
import ReactDOM from 'react-dom';
import { AppContainer } from 'react-hot-loader';
import CartsView from './components/CartsView';

const CartsApp = () => {
	return ReactDOM.render(
		<AppContainer>
			<CartsView />
		</AppContainer>,
		document.getElementById('carts_app')
	);
};

export default CartsApp;
