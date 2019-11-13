class BookingsController < ApplicationController
  before_action :authenticate_user!, except: %w(payment show)

  def index
    @class = 'bookings'
  end

  def show
    if user_signed_in?
      @class = 'bookings'
      find_booking
      @charge = @booking.charge
      @booking.update_read(current_user, true)
      @booking.update_notification(current_user)
      load_data
    else
      @booking = Booking.find_by_token(params[:id])
      load_data
      render 'guest_show'
    end
  end

  def payment
    @package = Package.friendly.find(params[:package_id])
    @venue = @package.venue
    booking = Booking.find_by_package_id_and_sender_id_and_token(
      @package.id, (user_signed_in? ? current_user.id : nil), params[:booking_id])
    fail ActiveRecord::RecordNotFound unless booking.present?
    validate_booking(booking)
    @booking = booking.decorate

  end

  private

  def validate_booking(booking)
    message = 'Sorry, no actions are allowed. Order expired!'
    redirect_to :back, flash: { error: message } if booking.expired?
  end

  def find_booking
    booking = Booking.find_by_token(params[:id])
    fail ActiveRecord::RecordNotFound unless booking.present?
    @booking = booking.decorate
  end

  def load_data
    @venue = @booking.venue
    @sender = @booking.sender
    @recipient = @booking.recipient
    @charge = @booking.charge
  end
end
