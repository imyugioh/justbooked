class AddPackageIdToBookings < ActiveRecord::Migration
  def change
    add_reference :bookings, :package, index: true, foreign_key: true
  end
end
