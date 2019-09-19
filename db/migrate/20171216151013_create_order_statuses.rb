class CreateOrderStatuses < ActiveRecord::Migration
  def change
    create_table :order_statuses do |t|
      t.integer :order_id, index: true, null: false
      t.integer :user_id
      t.string :status, null: false
      t.timestamps null: false
    end
  end
end
