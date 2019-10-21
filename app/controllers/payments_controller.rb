class PaymentsController < ApplicationController

    def new
    end

    def index
      render :success
    end

    # "stripeToken"=>"tok_C8JfxZNcGX0ziG", "stripeEmail"=>"imstevecho@yahoo.com", "stripeAmount"=>"8162"
    # {
    #              "cart" => [
    #     [0] {
    #          "menu_id" => "2",
    #         "quantity" => 1
    #     },
    #     [1] {
    #          "menu_id" => "3",
    #         "quantity" => 2
    #     }
    # ],
    #        "first_name" => "Steve",
    #         "last_name" => "Cho",
    #     "order_date"    => "01/13/18",
    #       "more_detail" => "great",
    #       "order_total" => 40,
    #   "order_sales_tax" => 5.2,
    # "delivery_distance" => 36.42,
    #      "delivery_fee" => 36.42,
    #        "total_fees" => 81.62,
    #  "delivery_address" => "100 Bloor St W, Toronto, ON M5S 3L7, Canada",
    #           "chef_id" => 2
    # }

    def create

        stripe_email = params[:stripeEmail]
        stripe_token = params[:stripeToken]
        stripe_amount = params[:stripeAmount]
        order_detail = JSON.parse(params[:orderDetail])

        puts "......................order detail"
        puts order_detail

        chef = Chef.find_by_id(order_detail['chef_id']);

        order_detail['order_total'] = order_detail['order_total'].to_f * 100
        order_detail['order_sales_tax'] = order_detail['order_sales_tax'].to_f * 100
        order_detail['delivery_fee'] = order_detail['delivery_fee'].to_f * 100
        order_detail['delivery_distance'] = order_detail['delivery_distance'].to_f * 100
        order_detail['total_fees'] = order_detail['total_fees'].to_f * 100

        purchase = PaymentService.create(stripe_email, stripe_token, stripe_amount, order_detail, current_user, chef)

        if purchase
            render :success

            puts '>>>>>>>>>>>>>>>>>>>>>start order'

            chef = Chef.find_by_id(order_detail['chef_id'])

            ordered_user = current_user

            if ordered_user.nil?
              ordered_user = OpenStruct.new(email: stripe_email, first_name: order_detail['first_name'])
            end

            @user = ordered_user
            @user.phone = order_detail['delivery_phone_number']
            @user.save

            OrderMailer.book_order(ordered_user, chef, order_detail['delivery_phone_number']).deliver
            OrderMailer.receive_order(chef, chef.user.token, purchase.id).deliver
            puts '>>>>>>>>>>>>>>>>>>>>finish_order'
        else
            render :fail
        end
    end


    def success
    end

    def fail
    end


end
