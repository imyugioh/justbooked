class ChangePhoneNumberType < ActiveRecord::Migration
  def change
    change_column :chefs, :phone, :string
  end
end
