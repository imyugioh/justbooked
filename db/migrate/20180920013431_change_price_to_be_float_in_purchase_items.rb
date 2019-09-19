class ChangePriceToBeFloatInPurchaseItems < ActiveRecord::Migration
  def change
    change_column :purchase_items, :item_price, :float
    change_column :purchase_items, :sub_total, :float
  end
end
