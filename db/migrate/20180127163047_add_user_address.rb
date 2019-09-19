class AddUserAddress < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :streetnumber, :string
    add_column :users, :street_name, :string
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :city, :string
    add_column :users, :neighborhood, :string
    add_column :users, :state, :string
    add_column :users, :state_code, :string
    add_column :users, :zip, :string
    add_column :users, :country, :string, default: 'Canada'
  end
end
