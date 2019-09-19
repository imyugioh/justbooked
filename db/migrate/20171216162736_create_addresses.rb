class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_type
      t.integer :order_id
      t.integer :user_id
      t.string :email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :comment
      t.string :contact_phone

      t.timestamps null: false
    end
  end
end
