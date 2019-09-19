class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.references :cart, index: true
      t.references :address
      t.string :delivery_type
      t.string :order_type
      t.string :email
      t.string :description
      t.string :currency, null: false
      t.integer :customer_id, null: false
      t.string :card, null: false
      t.decimal :sales_tax, precision: 10, scale: 2, null: false
      t.decimal :delivery_fee, precision: 10, scale: 2, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.timestamps null: false
    end
  end
end
