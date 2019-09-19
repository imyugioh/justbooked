class AddDeliveryInfoToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :delivery_info, :jsonb
  end
end
