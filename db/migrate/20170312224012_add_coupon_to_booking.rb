class AddCouponToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :coupon, :string
    add_column :bookings, :coupon_refund, :boolean, default: false
    add_column :bookings, :coupon_refund_details, :json
  end
end
