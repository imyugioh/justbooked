class CreatePaymentAccounts < ActiveRecord::Migration
  def change
    create_table :payment_accounts do |t|
      t.integer :user_id
      t.integer :chef_id
      t.string :name
      t.string :account_number
      t.string :currency
      t.string :routing_number
      t.string :business_type
      t.string :business_name
      t.string :business_tax_id

      t.timestamps null: false
    end
  end
end
