class PaymentService

    def self.create(stripe_email, stripe_token, stripe_amount, order_detail, user, chef)
        purchase = nil
        ActiveRecord::Base.transaction do
            ap order_detail

            # Amount in cents
            if user.present?
                stripe_account = user.find_or_create_stripe_account(stripe_token)
                stripe_customer_id = stripe_account.id
                user_desc = user.stripe_desc
                user_id = user.id
                puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.user id"
                puts user.id
            else
                stripe_account = Stripe::Customer.create(
                    email: stripe_email,
                    source: stripe_token
                )
                stripe_customer_id = stripe_account.id
                user_desc = stripe_email.slice(0..21)
                user_id = nil
                puts ">>>>>>>> just created stripe guest user customer id: #{stripe_customer_id}"
            end


            stripe_amount = stripe_amount.to_i
            order_date = Time.strptime(order_detail['order_date'], "%m/%d/%Y").in_time_zone
            service_fee = (stripe_amount * chef.transaction_fee/100.0).to_i
            chef_amount = stripe_amount - service_fee

            puts ">>>>>> stripe_amount: #{stripe_amount}"
            puts ">>>>>> amount: #{stripe_amount}"
            puts ">>>>>> chef amount: #{chef_amount}"
            puts ">>>>>> service fee: #{service_fee}"
            puts ">>>>>> chef_amount + service_fee = #{stripe_amount}"
            puts ">>>>>> transaction_fee: #{chef.transaction_fee}";

            purchase = Purchase.create(
                user_id: user_id,
                first_name: order_detail['first_name'],
                last_name: order_detail['last_name'],
                email: stripe_email,
                cart_id: order_detail['cart_id'],
                phone_number: order_detail['delivery_phone_number'],
                chef_id: order_detail['chef_id'],
                order_type: order_detail['order_type'],
                order_date: order_date,
                order_time: order_detail['order_time'],
                delivery_address: order_detail['delivery_address'],
                delivery_distance: order_detail['delivery_distance'],
                more_detail: order_detail['more_detail'],
                promo_code: order_detail['promo_code'],
                stripe_token: stripe_token,
                amount: stripe_amount,
                chef_amount: chef_amount,
                description: user_desc,
                stripe_customer_id: stripe_customer_id,
                items_total: order_detail['order_total'].to_i,
                sales_tax: order_detail['order_sales_tax'].to_i,
                delivery_fee: order_detail['delivery_fee'].to_i,
                total_price: order_detail['total_fees'].to_i,
                service_fee: service_fee.to_i
            )

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

            if purchase
                order_detail['cart'].each do |item|
                    menu = Menu.find(item['menu_id'])
                    if menu
                        unit_price = menu.price.to_f
                        amount = item['total_menus_count'].to_i
                        sub_total = item['total'].to_f
                    end

                    parent_item = PurchaseItem.create(
                        user_id: user_id,
                        purchase_id: purchase.id,
                        amount: amount,
                        sub_total: sub_total,
                        model_id: menu.id,
                        model_type: 'Menu',
                        item_price: unit_price,
                        detail: item['special_instructions']
                    )

                    item['menu_items_counts'].each do |menu_item_id, qty|
                        if qty.to_i > 0
                            menu_item = MenuItem.find(menu_item_id)

                            PurchaseItem.create(
                                user_id: user_id,
                                purchase_id: purchase.id,
                                amount: qty,
                                sub_total: menu_item.price * qty,
                                model_id: menu_item.id,
                                model_type: 'MenuItem',
                                item_price: menu_item.price,
                                parent_id: parent_item.id
                            )
                        end
                    end

                    item['addon_counts'].each do |addon_id, qty|
                        if qty.to_i > 0
                            addon = Addon.find(addon_id)

                            PurchaseItem.create(
                                user_id: user_id,
                                purchase_id: purchase.id,
                                amount: qty,
                                sub_total: addon.price * qty,
                                model_id: addon.id.to_i,
                                model_type: 'Addon',
                                item_price: addon.price,
                                parent_id: parent_item.id
                            )
                        end
                    end
                end
            end
            purchase
        end
        rescue Stripe::CardError => e
            result[:error_message] = e.message
        purchase
    end

    def destroy(device)
      ActiveRecord::Base.transaction do
      end
    end

    def update(device, attributes, force_serial_number = false)
    end

    private


    def create_strip_account(stripe_email, stripe_token)
        account = nil
        begin
            account = Stripe::Customer.create(
                email: stripe_email,
                source: stripe_token
            )
        rescue Stripe::APIError => e
            puts ">>>>>>>>>>>> Can not create Stripe User. API Error #{e}"
        end
        account
    end

end