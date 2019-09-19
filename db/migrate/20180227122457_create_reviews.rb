class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :chef_id
      t.integer :menu_id
      t.integer :rate
      t.string :feedback

      t.timestamps null: false
    end
  end
end
