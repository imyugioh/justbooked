class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.integer :menu_id, null: false
      t.string :name, null: false
      t.string :desc
      t.decimal :price, precision: 8, scale: 2, null: false
      t.timestamps null: false
    end
  end
end
