class AddPackageInfoToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :package_info, :json
  end
end
