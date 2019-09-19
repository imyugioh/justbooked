class RenameRequestsToBookings < ActiveRecord::Migration
  def change
    drop_table :bookings
    rename_table :requests, :bookings
  end
end
