class OrderMailer < ApplicationMailer
  # add_template_helper(ApplicationHelper)
  layout false

  def send_sms(phone, msg)
    # puts ">>>>>>>>>>>>>>>>>>>number"
    # puts phone
    # puts ENV['TWILIO_PHONE_NUMBER'] 

    phone = phone_number(phone)

    if !phone.blank?
      @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      @client.messages.create(
        :from => ENV['TWILIO_PHONE_NUMBER'],
        :to => phone,
        :body => msg
      )
    end
  end


  def book_order(user, chef, delivery_phone_number)
  	@user = user
  	@chef = chef
  	# puts '------------book order mailer------------'
  	# puts @user
  	# puts @chef.first_name
    email = emailto(@user.email)
  	mail to: email, subject: 'Just Booked - Order in queue' do |format|
  		format.html {render "book_order"}
  		format.text {render text: "Book Order"}  	
  	end

    puts ">>>>>>>>>>>>>>>>>sms"

    message = "Hi, " + @user.first_name + "\n" + "\n" +
              "Your order has been delivered to "+ @chef.name + "\n" +
              "You will receive a response soon!" + "\n" + "\n" +
              "Best" + "\n" +
              "The Justbooked Team" + "\n" +
              "www.justbooked.com"

    puts message

    delivery_phone_number = phone_number(delivery_phone_number)
    send_sms(delivery_phone_number, message)
  end

  def receive_order(chef, chef_token, purchase_id)
  	@chef = chef
    @chef_token = chef_token
    @purchase_id = purchase_id
    @purchase = Purchase.find_by_id(purchase_id)
  	# puts '------------receive order mailer------------'
  	# puts @chef.first_name
    email = emailto(@chef.email)

    case @purchase.order_type
    when 'delivery' # delivery
      @text = 'a delivery order'
    when 'pickup' # pickup
      @text = 'a pick up order'
    else # onsite-cooking
      @text = 'an onsite cooking, booking request'
    end

  	mail to: email, subject: 'New Order! - Just Booked' do |format|
  		format.html {render "receive_order"}
  		format.text {render text: "Receive Order"}  	
  	end

    if @chef.email_sec.present?
      email_sec = emailto(@chef.email_sec)

      mail to: email_sec, subject: 'New Order! - Just Booked' do |format|
        format.html {render "receive_order"}
        format.text {render text: "Receive Order"}    
      end
    end

    message = "Hi, "+ @chef.first_name + "\n" + "\n" +
            "You've received " + @text + ". Please visit the below link to view order details." + "\n" + "\n" +
            "http://justbooked.com/orders/token_order_details/" + @purchase_id.to_s + "/" + @chef_token.to_s + "\n" + "\n" +
            "Best" + "\n" +
            "The Justbooked Team" + "\n" +
            "http://www.justbooked.com"
    puts message


    phone = phone_number(chef.phone)
    send_sms(phone, message)

    if chef.phone_sec.present?
      phone_sec = phone_number(chef.phone_sec)
      send_sms(phone_sec, message)
    end
  end

  def accepted_order_chef(chef, purchase)

    # puts '>>>>>>>>>>chef'
    # puts chef.email
    @chef = chef
    @menus ||= []
    @purchase = purchase
    purchase_menus = @purchase.menus

    purchase_menus.each do |item|
      menu = Menu.find_by_id(item.model_id)
      @menus.push(menu)
    end

    email = emailto(@chef.email)
    mail to: email, subject: 'Just Booked - Vendor Receipt' do |format|
      format.html {render "accepted_order_chef"}
      format.text {render text: "Accpeted Order Chef"} 
    end

    if @chef.email_sec.present?
      email_sec = emailto(@chef.email_sec)
      
      mail to: email_sec, subject: 'Just Booked - Vendor Receipt' do |format|
        format.html {render "accepted_order_chef"}
        format.text {render text: "Accpeted Order Chef"} 
      end
    end

    message = "Hi, "+ @chef.first_name + "\n" + "\n" +
              "You got paid" + "\n" +
              "Subtotal: $" + (@purchase.items_total/100.00).to_s + "\n"+
              "HST(13%): $" + (@purchase.sales_tax/100.00).to_s + "\n"+
              "Just Booked fee: -$" + (@purchase.service_fee/100.00).to_s + "\n"+
              "Delivery fee: $" + (@purchase.delivery_fee/100.00).to_s + "\n" +
              "Total Received: $" + ((@purchase.total_price - @purchase.service_fee)/100.00).to_s + "\n"
    puts message
    phone = phone_number(chef.phone)
    send_sms(phone, message)

    if chef.phone_sec.present?
      phone_sec = phone_number(chef.phone_sec)
      send_sms(phone_sec, message)
    end
  end

  def accepted_order_customer(purchase)
    @menus ||= []
    @purchase = purchase
    purchase_menus = @purchase.menus

    purchase_menus.each do |item|
      menu = Menu.find_by_id(item.model_id)
      @menus.push(menu)
    end

    email = emailto(@purchase.email)
    mail to: email, subject: 'Just Booked - Your order has been processed' do |format|
      format.html {render "accepted_order_customer"}
      format.text {render text: "Accpeted Order Customer"} 
    end

    message = "Hi, "+ @purchase.first_name + "\n" + "\n" +
              "Your order has been processed. Here's your receipt " + "\n" +
              "Subtotal: $" + (@purchase.items_total/100.00).to_s + "\n" +
              "HST(13%): $" + (@purchase.sales_tax/100.00).to_s + "\n" +
              "Delivery fee: $" + (@purchase.delivery_fee/100.00).to_s + "\n"+
              "Total Paid: $" + ((@purchase.total_price)/100.00).to_s
    puts message

    phone = phone_number(purchase.phone_number)
    send_sms(phone, message)
  end

  def send_review_chef(review)
    @review = review
    @chef = Chef.find_by(:id => review.chef_id)
    @menu = Menu.find_by(:id => review.menu_id)

    email = emailto(@chef.email)
    mail to: email, subject: "You’ve received a new review from " + @review.first_name + " - Just Booked" do |format|
      format.html {render "send_review_chef"}
      format.text {render text: "Send Review to Chef"} 
    end

    if @chef.email_sec.present?
      email_sec = emailto(@chef.email_sec)
      
      mail to: email_sec, subject: "You’ve received a new review from " + @review.first_name + " - Just Booked" do |format|
        format.html {render "send_review_chef"}
        format.text {render text: "Send Review to Chef"} 
      end
    end
    message = "Hi, " + @chef.first_name + "\n" + "\n" +
              "You've got a new review from " + @review.first_name + ".\n" +
              "This is what " + @review.first_name + " has to say" + "\n" +
              @menu.name + "\n" +
              "Rate: " + (@review.rating).to_s + "\n" +
              "Review: " + "\n" +
              @review.feedback + "\n"
    puts message

    phone = phone_number(@chef.phone)
    send_sms(@chef.phone, message)

    if chef.phone_sec.present?
      phone_sec = phone_number(chef.phone_sec)
      send_sms(phone_sec, message)
    end
  end

  def send_review_customer(chef, purchase)
    @chef = chef
    @menus ||= []
    @purchase = purchase
    purchase_menus = @purchase.menus
    
    purchase_menus.each do |item|
      menu = Menu.find_by_id(item.model_id)
      @menus.push(menu)
    end

    subject = @purchase.first_name + ", did " + @chef.first_name + "'s meal meet your expectations? - Just Booked"

    email = emailto(@purchase.email)
    mail to: email, subject: subject do |format|
      format.html {render "send_review_customer"}
      format.text {render text: "Send Review to Chef"} 
    end

    message = @purchase.first_name + ", did " + @chef.first_name + " meet your expectations? Leave feedback here." + "\n" +
              "http://justbooked.com/reviews/"+ @purchase.token + "\n" + "\n" +
              "Your reviews will post publicly " + "as " + @purchase.first_name + ".\n"
    puts message

    phone = phone_number(purchase.phone_number)
    send_sms(phone, message)
  end

  def decline_order(purchase, chef)
    @user = purchase
    @chef = chef

    email = emailto(@user.email)
    mail to: email, subject: "Just Booked - Your order has been declined" do |format|
      format.html {render "decline_order"}
      format.text {render text: "Decline Order"} 
    end

    message = "Hi, "+ @user.first_name + "\n" + "\n" +
            "Unfortunately, " + @chef.name + " isn't able to service your order at this time." + "\n" + "\n" +
            "This doesn't usually happen! Sorry for the inconvienience." + "\n" + "\n" +
            "Best" + "\n" +
            "The Justbooked Team" + "\n" +
            "http://www.justbooked.com"
    puts message

    phone = phone_number(purchase.phone_number)
    send_sms(phone, message)
  end


  def phone_number(phone)
    if (ENV['RECEIVE_ALL_SMS'].present?)
      original_phone = phone
      phone = ENV['RECEIVE_ALL_SMS']
      puts ">>> intercept SMS phone from #{original_phone} to #{phone}"
    end
    phone
  end


  def emailto(email_address)
    if (ENV['RECEIVE_ALL_EMAIL'].present?)
      original_email = email_address
      email_address = ENV['RECEIVE_ALL_EMAIL']
      puts ">>> intercept email from #{original_email} to #{email_address}"
    end
    email_address
  end


end
