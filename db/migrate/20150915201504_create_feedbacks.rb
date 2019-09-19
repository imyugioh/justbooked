class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.text :message

      t.timestamps null: false
    end
  end
end
