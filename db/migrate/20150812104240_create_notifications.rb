class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :noteable, polymorphic: true, index: true
      t.string :message_key
      t.boolean :read, default: false
      t.integer :user_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
