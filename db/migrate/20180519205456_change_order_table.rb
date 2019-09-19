class ChangeOrderTable < ActiveRecord::Migration
  def change
    rename_column :purchases, :delivery_date, :order_date
    rename_column :purchases, :delivery_time, :order_time
  end
end
