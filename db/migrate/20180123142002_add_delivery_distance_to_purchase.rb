class AddDeliveryDistanceToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :delivery_distance, :integer, default: 0
  end
end
