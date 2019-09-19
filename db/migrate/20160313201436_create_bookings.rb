class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.belongs_to :venue, index: true, foreign_key: true
      t.belongs_to :package, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :recipient_id, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.date :start_date
      t.string :start_time
      t.string :end_time
      t.string :event_type
      t.integer :guests_number
      t.text :details

      t.timestamps null: false
    end
  end
end
