class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)


  def chef_invitation(chef, email)
    @user = email
    # I am overriding the 'to' default
    mail(to: email, subject: 'Chef invitation mail')
  end

  # --------------------------------- old stuff ------------------------------------------------------
  def after_confirmation(user)
    @user = user
    mail to: user.email, from: "#{ENV['APPNAME']} <#{ENV['EMAIL_FROM']}>", subject: "Welcome to #{ENV['APPNAME']}"
  end

  def booking_notification(booking_id)
    prepare_email_data(booking_id)
    @user = @booking.recipient
    email = (@venue.email.present? && !@venue.email.empty?) ? @venue.email : @user.email
    mail to: recipient_email(email), subject: "New order for #{@venue.name}" if @user.present?
  end

  def charge_notification(booking_id, user)
    prepare_email_data(booking_id)
    @user = user
    if @user.nil? || @user == @booking.sender
      email = @booking.email
      subject = "Your food is being prepared. Receipt attached."
    else
      email = (@venue.email.present? && !@venue.email.empty?) ? @venue.email : @user.email
      subject = "Payment received for order #{@booking.order_id} on #{l @booking.date_start, format: :long}, #{@booking.time_start}."
    end
    mail to: recipient_email(email), subject: subject
  end

  def notify_client_new_booking(booking)
    @user = booking.sender
    prepare_email_data(booking)

    email =  @user ? @user.email : @booking.email
    mail to: recipient_email(email), subject: "Order request for #{@venue.name} - order sent to chef"
  end

  def new_comment_notification(request, user, action)
    @request = request
    @user = user
    @action = action
    mail to: recipient_email(user.email), subject: 'You have a new reply to your request'
  end

  def booking_status_changed(booking)
    prepare_email_data(booking)
    @user = booking.sender
    @status = Booking::STATUS[booking.status]
    email =  @user ? @user.email : @booking.email
    mail to: recipient_email(email), subject: "Order request for #{@venue.name} - #{@status == 'rejected' ? 'unavailable' : @status}"
  end

  def discount_refund(booking_id)
    prepare_email_data(booking_id)
    @user = @booking.recipient
    email = (@venue.email.present? && !@venue.email.empty?) ? @venue.email : @user.email
    mail to: recipient_email(email), subject: "Coupon reimbursement for #{@booking.package.title}"
  end

  private

  def prepare_email_data(booking_id)
    @booking = Booking.find(booking_id)
    @package = @booking.package
    @venue = @booking.venue
  end

  def recipient_email(email)
    email
  end


end
