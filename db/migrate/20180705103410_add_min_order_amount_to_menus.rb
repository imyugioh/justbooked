class AddMinOrderAmountToMenus < ActiveRecord::Migration
  def change
  	add_column :menus, :min_order_amount, :integer, :default => 1
  end
end
