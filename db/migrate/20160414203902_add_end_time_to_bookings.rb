class AddEndTimeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :end_time, :string
  end
end
