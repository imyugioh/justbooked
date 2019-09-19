class RemoveColumnsFromBookings < ActiveRecord::Migration
  def self.up
    rename_column :bookings, :coupon, :coupon_name
    remove_column :bookings, :coupon_refund
    remove_column :bookings, :coupon_refund_details
  end

  def self.down
    rename_column :bookings, :coupon_name, :coupon
    add_column :bookings, :coupon_refund
    add_column :bookings, :coupon_refund_details
  end
end
