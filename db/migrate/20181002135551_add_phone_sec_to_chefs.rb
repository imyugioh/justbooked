class AddPhoneSecToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :phone_sec, :string
  end
end
