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

end
