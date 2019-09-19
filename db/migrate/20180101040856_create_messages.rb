class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :message
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
