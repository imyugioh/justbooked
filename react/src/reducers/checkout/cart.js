import { ADD_MENU, REMOVE_MENU, REMOVE_ALL, CART_DATA_RECEIVED } from '../../constants/action_types'
import _ from 'lodash';

export default function Menus(state = [], action) {
	let newState = []

	switch (action.type) {
		case ADD_MENU:

	  	const menu_id = action.id
			let current_state = _.clone(state, true);
			let current_menu = current_state[menu_id]
			let menu_item = current_menu[0]

			current_menu.push(menu_item)
      window.add_cart_menu(menu_item)

			return current_menu
		case REMOVE_MENU:
			var index = state.findIndex(menu => menu.menu_id === action.id.toString())
			var menu = _.find(state, {menu_id: action.id.toString()})
			if (menu.quantity > 1) {
				menu.quantity -= 1
				newState = [
					...state.slice(0, index), // everything before current post
					menu,
					...state.slice(index + 1), // everything after current post
				]
			} else {
				newState = [
					...state.slice(0, index), // everything before current post
					...state.slice(index + 1), // everything after current post
				]
			}
			return newState
		case REMOVE_ALL:
			var index = state.findIndex(menu => menu.menu_id === action.id.toString())
			var menu = _.find(state, {menu_id: action.id.toString()})
			newState = [
				...state.slice(0, index), // everything before current post
				...state.slice(index + 1), // everything after current post
			]
			return newState
		case CART_DATA_RECEIVED:
			// console.log("............. cart data received")
			// console.log(action.data)
			// return action.data
			return state
		default:
			return state
	}
}


function findCartMenu(state, menu_id) {
	return _.find(state, {id: menu_id.toString()})
}
