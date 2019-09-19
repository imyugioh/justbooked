import request from 'superagent'
import {GET_CART_DATA, CART_DATA_RECEIVED, SUBMIT_ORDER, ORDER_RESULT_RECEIVED} from "../constants/action_types";
const dataService = store => next => action => {
	/*
  Pass all actions through by default
  */
	next(action)

	switch (action.type) {
		case GET_CART_DATA:
			/*
      In case we receive an action to send an API request, send the appropriate request
      */
			request
				.get('/api/cart/8.json')
				.end((err, res) => {
					if (err) {
						/*
            in case there is any error, dispatch an action containing the error
            */
						return next({
							type: 'GET_CART_DATA_ERROR',
							err
						})
					}


					const data = JSON.parse(res.text)
					console.log(">>>>>>>>>>>> in service")
					console.log(data)
					/*
          Once data is received, dispatch an action telling the application
          that data was received successfully, along with the parsed data
          */
					next({
						type: CART_DATA_RECEIVED,
						data
					})
				})
			break
		/*
    Do nothing if the action does not interest us
    */
		case SUBMIT_ORDER:
			console.log("came here for oder.............")
			console.log(action)

			request
				.post('/api/checkout')
				.send(action.order_info)
				.set('accept', 'json')
				.end((err, res) => {
					if (err) {
						/*
            in case there is any error, dispatch an action containing the error
            */
						return next({
							type: 'SUBMIT_ORDER_ERROR',
							err
						})
					}


					const data = JSON.parse(res.text)
					console.log(">>>>>>>>>>>> Got order result")
					console.log(data)
					/*
          Once data is received, dispatch an action telling the application
          that data was received successfully, along with the parsed data
          */
					next({
						type: ORDER_RESULT_RECEIVED,
						data
					})
				})
			break
		default:
			break
	}

};

export default dataService
