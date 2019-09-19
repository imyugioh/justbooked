class AddPreOrderToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :pre_order_notice_hour, :integer, default: 24
    add_column :chefs, :pre_order_min_order_amount, :decimal,  precision: 8, scale: 2
    add_column :chefs, :delivery_fee, :decimal,  precision: 8, scale: 2
    add_column :chefs, :free_delivery_min_order_amount, :decimal,  precision: 8, scale: 2
    add_column :chefs, :min_fee_for_onsite_cooking, :decimal,  precision: 8, scale: 2
    add_column :chefs, :onsite_cooking_available, :boolean, default: false
    add_column :chefs, :pickup_available, :boolean, default: true
  end
end
