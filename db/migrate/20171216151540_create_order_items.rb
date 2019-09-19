class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :menu_id, index: true, null: false
      t.integer :order_id, index: true, null: false
      t.integer :user_id, index: true
      t.decimal :unit_price, null: false
      t.integer :quantity, index: true, null: false
      t.decimal :total_price, index: true, null: false

      t.timestamps null: false
    end
  end
end
