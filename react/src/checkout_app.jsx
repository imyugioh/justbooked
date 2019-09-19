import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import {createStore, applyMiddleware} from 'redux'
import {AppContainer} from 'react-hot-loader'
import App from './components/checkout/App'
import checkoutReducer from './reducers/checkout/index'
import { GET_CART_DATA } from './constants/action_types'
import dataService from './services/checkout_service'


let initialState = {cart: window.getCartItems()}
const store = createStore(checkoutReducer, initialState, applyMiddleware(dataService))

ReactDOM.render(
	<AppContainer>
		<Provider store={store}>
			<App/>
		</Provider>
	</AppContainer>,
	document.getElementById('checkout-app')
);


// store.dispatch({type: GET_CART_DATA})

