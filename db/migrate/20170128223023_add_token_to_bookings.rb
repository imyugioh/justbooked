class AddTokenToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :token, :string
    Booking.all.map(&:generate_token)
  end
end
