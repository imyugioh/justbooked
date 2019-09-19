class AddCertifiedToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :certified, :boolean, default: false
  end
end
