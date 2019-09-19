class AddDiscountToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :discount, :decimal, precision: 5, scale: 2

    Package.all.each do |p|
      next unless p.discount_price
      pc = ((p.regular_price - p.discount_price) / p.regular_price) * 100.00
      p.update_attributes(discount: pc)
    end
  end
end
