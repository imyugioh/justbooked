namespace :test_data do
  desc "Create test payment accounts for all chefs"
  task chef_payment_account: :environment do
    chefs = Chef.all

    chefs.each do |chef|
      puts "creating/updating payment account for #{chef.name}"
      if payment_account = chef.payment_account
        payment_account.first_name = chef.first_name
        payment_account.last_name =  chef.last_name
        payment_account.account_number = "000123456789"
        payment_account.routing_number = "11000-000"
        payment_account.stripe_terms_of_services = "1"
        payment_account.ip_address = "192.179.0.1"
        payment_account.dob_day = 31
        payment_account.dob_month = 10
        payment_account.dob_year = 1988

        payment_account.save
      else
        puts ">>>>>>> chef #{chef.id} doesn't have payment account"
      end
    end
  end


  desc "Test import"
  task import: :environment do
    # {"cart"=>[{"chef_id"=>110, "menu_id"=>"237", "menu_name"=>"Bagels [Serves 12]", "menu_img"=>"https://venuezz-production.s3.amazonaws.com/assets/menu/000/001/846/menu_thumb/jewish-holidays-choose-your-own-bagels-lox-cream-cheese.ac3f1fd3f29f6a5b04ba43b1061bb165.jpg?1530298232", "max_delivery_distance"=>20, "total"=>"3024.00", "total_menus_count"=>"7", "special_instructions"=>"", "addon_counts"=>{"8"=>0, "9"=>0}, "menu_items_counts"=>{"5"=>6, "6"=>1}}, {"chef_id"=>110, "menu_id"=>"238", "menu_name"=>"Grilled Breakfast Wraps (Assorted) [Serves 12]", "menu_img"=>"https://venuezz-production.s3.amazonaws.com/assets/menu/000/001/850/menu_thumb/turkey-bacon-ranch-wraps-5.jpg?1530299413", "max_delivery_distance"=>20, "total"=>"181.00", "total_menus_count"=>"2", "special_instructions"=>"", "addon_counts"=>{"6"=>1, "7"=>0}, "menu_items_counts"=>{"3"=>1, "4"=>1}}], "cart_id"=>17830, "first_name"=>"Steve", "last_name"=>"Cho", "delivery_phone_number"=>"4166696609", "order_type"=>"delivery", "order_date"=>"09/15/18", "order_time"=>"11:00 AM", "more_detail"=>"test", "order_total"=>3205, "order_sales_tax"=>419.90000000000003, "delivery_distance"=>0, "delivery_fee"=>25, "total_fees"=>3649.9, "delivery_address"=>"100 Bloor St W, Toronto, ON M5S 3L7, Canada", "chef_id"=>110}            
    # [
    #     [0] {
    #                       "chef_id" => 110,
    #                       "menu_id" => "237",
    #                     "menu_name" => "Bagels [Serves 12]",
    #                      "menu_img" => "https://venuezz-production.s3.amazonaws.com/assets/menu/000/001/846/menu_thumb/jewish-holidays-choose-your-own-bagels-lox-cream-cheese.ac3f1fd3f29f6a5b04ba43b1061bb165.jpg?1530298232",
    #         "max_delivery_distance" => 20,
    #                         "total" => "3024.00",
    #             "total_menus_count" => "7",
    #          "special_instructions" => "",
    #                  "addon_counts" => {
    #             "8" => 0,
    #             "9" => 0
    #         },
    #             "menu_items_counts" => {
    #             "5" => 6,
    #             "6" => 1
    #         }
    #     },

    order_detail = {"cart"=>[{"chef_id"=>110, "menu_id"=>"237", "menu_name"=>"Bagels [Serves 12]", "menu_img"=>"https://venuezz-production.s3.amazonaws.com/assets/menu/000/001/846/menu_thumb/jewish-holidays-choose-your-own-bagels-lox-cream-cheese.ac3f1fd3f29f6a5b04ba43b1061bb165.jpg?1530298232", "max_delivery_distance"=>20, "total"=>"3024.00", "total_menus_count"=>"7", "special_instructions"=>"", "addon_counts"=>{"8"=>0, "9"=>0}, "menu_items_counts"=>{"5"=>6, "6"=>1}}, {"chef_id"=>110, "menu_id"=>"238", "menu_name"=>"Grilled Breakfast Wraps (Assorted) [Serves 12]", "menu_img"=>"https://venuezz-production.s3.amazonaws.com/assets/menu/000/001/850/menu_thumb/turkey-bacon-ranch-wraps-5.jpg?1530299413", "max_delivery_distance"=>20, "total"=>"181.00", "total_menus_count"=>"2", "special_instructions"=>"", "addon_counts"=>{"6"=>1, "7"=>0}, "menu_items_counts"=>{"3"=>1, "4"=>1}}], "cart_id"=>17830, "first_name"=>"Steve", "last_name"=>"Cho", "delivery_phone_number"=>"4166696609", "order_type"=>"delivery", "order_date"=>"09/15/18", "order_time"=>"11:00 AM", "more_detail"=>"test", "order_total"=>3205, "order_sales_tax"=>419.90000000000003, "delivery_distance"=>0, "delivery_fee"=>25, "total_fees"=>3649.9, "delivery_address"=>"100 Bloor St W, Toronto, ON M5S 3L7, Canada", "chef_id"=>110}

    order_detail['cart'].each do |item|
      puts item
      menu = Menu.find(item['menu_id'])
      if menu
        unit_price = menu.price.to_f
        amount = item['total_menus_count'].to_i
        sub_total = unit_price * amount
      end

      PurchaseItem.create(
          user_id: user_id,
          purchase_id: purchase.id,
          amount: amount,
          sub_total: sub_total,
          model_id: menu_id.to_i,
          model_type: 'Menu',
          menu_price: unit_price
      )

      item['menu_items_counts'].each do |menu_item_id, qty|
        menu_item = MenuItem.find(menu_item_id)
        ap menu_item

        PurchaseItem.create(
          user_id: user_id,
          purchase_id: purchase.id,
          amount: qty,
          sub_total: menu_item.price * qty,
          model_id: menu_item_id.to_i,
          model_type: 'MenuItem',
          menu_price: menu_item.price
        )

      end

      item['addon_counts'].each do |addon_id, qty|
        addon = Addon.find(addon_id)
        ap addon

        Addon.create(
          user_id: user_id,
          purchase_id: purchase.id,
          amount: qty,
          sub_total: addon.price * qty,
          model_id: addon_id.to_i,
          model_type: 'AddOn',
          menu_price: addon.price
        )
      end
    end

  end

end
