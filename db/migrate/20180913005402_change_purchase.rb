class ChangePurchase < ActiveRecord::Migration
  def change
    add_column :purchase_items, :model_type, :string
    rename_column :purchase_items, :item_id, :model_id
    add_index :purchase_items, :purchase_id
  end
end
