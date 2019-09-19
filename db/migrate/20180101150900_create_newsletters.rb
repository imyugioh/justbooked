class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :city
      t.string :name
      t.string :email

      t.timestamps null: false
    end
  end
end
