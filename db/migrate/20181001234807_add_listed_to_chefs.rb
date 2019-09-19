class AddListedToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :listed, :boolean, default: true
  end
end
