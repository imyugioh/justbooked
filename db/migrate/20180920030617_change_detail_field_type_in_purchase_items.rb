class ChangeDetailFieldTypeInPurchaseItems < ActiveRecord::Migration
  def change
    change_column :purchase_items, :detail, :text
  end
end
