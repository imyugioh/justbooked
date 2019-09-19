class AddFiltersToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :shareables, :boolean, null: false, default: false
    add_column :chefs, :individually_packaged, :boolean, null: false, default: false
    add_column :chefs, :price_category, :integer, null: false, default: 0
  end
end
