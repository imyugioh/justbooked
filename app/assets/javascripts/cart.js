// Lockr cart_items --> from Hash into Array
function get_cart_chef_id() {
  var chef_info = get_cart_chef_info()
  return chef_info.chef_id;
}

function get_cart_chef_info() {
  var chef_info = {};
  var cart_items = Lockr.get('cart_items') || [];
  if(cart_items.length > 0) {
    var menu_info = cart_items[0];
    chef_info = {
      chef_id: menu_info.chef_id,
      max_delivery_distance: menu_info.max_delivery_distance
    }
  }

  // console.log("chef ino: ", chef_info);

  return chef_info;
}

function getCartItems() {
  return Lockr.get('cart_items');
}

// get partial count for each menu item
function menu_cart_items(menu_id) {
  var cart_items = Lockr.get('cart_items');
  var partial_count = 0;

  cart_items.forEach(function(cart_item) {
    partial_count += parseInt(cart_item.menu_id, 10) === parseInt(menu_id, 10) ? parseInt(cart_item.total_menus_count, 10) : 0;
  });

  return partial_count;
}

function total_cart_items() {
  var total_count = 0;
  var cart_items = Lockr.get('cart_items');
  cart_items.forEach(function(cart_item) {
    total_count += parseInt(cart_item.total_menus_count, 10);
  });

  return total_count;
}


function add_cart_menu(menu) {
  var cart_items = Lockr.get('cart_items');
  cart_items.push(menu);
  Lockr.set('cart_items', cart_items);
  // console.log(Lockr.get('cart_items'))
}

function update_cart_menu(cart_item_id, menu) {
  var cart_items = Lockr.get('cart_items');
  cart_items[cart_item_id] = menu
  Lockr.set('cart_items', cart_items);
}

function remove_cart_menu(cart_item_id) {
  var cart_items = Lockr.get('cart_items');
  if(cart_items[cart_item_id]) {
    cart_items.splice(cart_item_id, 1);
  }

  Lockr.set('cart_items', cart_items);
  // console.log(Lockr.get('cart_items'))
}


function remove_all_cart_menus(menu_id) {
  var cart_items = Lockr.get('cart_items');

  if (_.has(cart_items, menu_id)) {
    delete cart_items[menu_id];
  } else {
    console.log("!!! ", menu_id, " does not exist to remove all cart menus");
  }

  Lockr.set('cart_items', cart_items);
  // console.log(Lockr.get('cart_items'))
}
