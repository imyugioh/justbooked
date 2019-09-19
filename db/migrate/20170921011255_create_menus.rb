class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.integer :chef_id
      t.decimal :price, precision: 8, scale: 2
      t.string :slug
      t.integer :asset_count
      t.integer  :position
      t.timestamps null: false
    end
  end
end
