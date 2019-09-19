class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :chef_id
      t.string :name
      t.string :email
      t.boolean :invitation_sent, default: false

      t.timestamps null: false
    end
  end
end
