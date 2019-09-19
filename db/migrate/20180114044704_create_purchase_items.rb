class CreatePurchaseItems < ActiveRecord::Migration
  def change
    create_table :purchase_items do |t|
      t.integer :user_id
      t.integer :purchase_id
      t.integer :menu_id
      t.integer :menu_price
      t.integer :amount
      t.integer :sub_total
      t.timestamps null: false
    end
  end
end
