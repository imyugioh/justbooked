export const getCartData = cart_id => {
	return {
		type: 'GET_CART_DATA',
		id: cart_id
	}
}

// Remove the first menu that matches the menu_id
export const removeOne = menu_id => {
	return {
		type: 'REMOVE_MENU',
		id: menu_id
	}
}

// Remove all the menus with the menu_id
export const removeAll = menu_id => {
	return {
		type: 'REMOVE_ALL',
		id: menu_id
	}
}

// Remove the first menu that matches the menu_id
export const addOne = menu_id => {
	return {
		type: 'ADD_MENU',
		id: menu_id
	}
}

// Submit order
export const submitOrder = order_info => {
	return {
		type: 'SUBMIT_ORDER',
		order_info: order_info
	}
}
