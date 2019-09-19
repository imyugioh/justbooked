class AddDetailToPurchaseItem < ActiveRecord::Migration
  def change
    add_column :purchase_items, :detail, :jsonb, default: {}
  end
end
