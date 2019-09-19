class AdjustPurchaseItems < ActiveRecord::Migration
  def change
    rename_column :purchase_items, :menu_id, :item_id
    rename_column :purchase_items, :menu_price, :item_price
    add_column :purchase_items, :item_type, :string, null: false, default: :Menu
  end
end
