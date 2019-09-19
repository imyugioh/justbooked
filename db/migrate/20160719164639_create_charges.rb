class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.belongs_to :booking, index: true, foreign_key: true
      t.money :amount
      t.money :service_fee
      t.date :charge_at
      t.boolean :captured, default: false
      t.integer :charge_attempts, default: 0
      t.json :stripe_response

      t.timestamps null: false
    end
  end
end
