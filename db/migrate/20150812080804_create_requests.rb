class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :sender_id, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.date :date_start
      t.string :time_start
      t.integer :estimated_guests_count
      t.integer :venue_id, index: true, foreign_key: true
      t.integer :recipient_id, index: true, foreign_key: true
      t.text :details
      t.text :event_type_id

      t.timestamps null: false
    end
  end
end
