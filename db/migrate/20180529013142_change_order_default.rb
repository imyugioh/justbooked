class ChangeOrderDefault < ActiveRecord::Migration
  def change
    change_column :purchases, :order_time, :string, :default => nil
  end
end
