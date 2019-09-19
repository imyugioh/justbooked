class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.integer :menu_id
      t.string :name
      t.string :desc
      t.decimal :price, precision: 8, scale: 2, null: false
      t.timestamps null: false
    end
  end
end
