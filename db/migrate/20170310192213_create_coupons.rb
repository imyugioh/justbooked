class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :card_token
      t.string :customer_id
      t.decimal :discount
      t.date :start_date
      t.date :end_date
      t.boolean :expired, default: false
      t.integer :limit, default: 1

      t.timestamps null: false
    end
  end
end
