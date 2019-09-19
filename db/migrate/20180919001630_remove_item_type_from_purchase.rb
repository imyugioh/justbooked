class RemoveItemTypeFromPurchase < ActiveRecord::Migration
  def change
    remove_column :purchase_items, :item_type
    add_column :purchase_items, :parent_id, :integer
  end
end
