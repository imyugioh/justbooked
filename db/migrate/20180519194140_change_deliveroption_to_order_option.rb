class ChangeDeliveroptionToOrderOption < ActiveRecord::Migration
  def change
    rename_column :purchases, :delivery_type, :order_type
  end
end
