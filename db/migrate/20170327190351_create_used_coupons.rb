class CreateUsedCoupons < ActiveRecord::Migration
  def change
    create_table :used_coupons do |t|
      t.belongs_to :booking, index: true, foreign_key: true
      t.belongs_to :coupon, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :confirmed, default: false
      t.boolean :coupon_refund, default: false
      t.json :coupon_refund_details

      t.timestamps null: false
    end
  end
end
