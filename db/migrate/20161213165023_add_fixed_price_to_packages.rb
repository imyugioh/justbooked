class AddFixedPriceToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :fixed_price, :boolean, default: false
  end
end
