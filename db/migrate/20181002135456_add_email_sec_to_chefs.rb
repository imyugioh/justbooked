class AddEmailSecToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :email_sec, :string
  end
end
