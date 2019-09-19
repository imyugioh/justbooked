class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :cart_id
      t.integer :chef_id
      t.string :phone_number
      t.date :delivery_date
      t.string :delivery_time
      t.string :delivery_type, default: 'delivery'
      t.string :delivery_address
      t.string :more_detail
      t.string :promo_code
      t.string :purchased_with, default: 'credit_cart'
      t.string :stripe_token
      t.integer :amount
      t.string :description
      t.string :currency, default: 'cad'
      t.string :stripe_customer_id
      t.integer :items_total
      t.integer :sales_tax
      t.integer :delivery_fee
      t.integer :total_price
      t.boolean :captured, default: false
      t.integer :charge_attempts, default: 0
      t.integer :service_fee, default: 0
      t.jsonb :stripe_response
      t.timestamps null: false
    end
  end
end
