export default function getMenu(menus, menu_id) {
	const menu = _.find(menus, {id: menu_id})
	return menu
}
