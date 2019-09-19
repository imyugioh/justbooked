class AddDefaultBookingTypeOptoinToAppSettings < ActiveRecord::Migration
  def change
    add_column :app_settings, :default_booking_type, :string, default: 'Dining Out'
  end
end
