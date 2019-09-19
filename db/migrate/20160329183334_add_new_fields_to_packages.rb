class AddNewFieldsToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :date_start, :datetime
    add_column :packages, :date_end, :datetime
    add_column :packages, :regular_price, :decimal, precision: 8, scale: 2
    add_column :packages, :discount_price, :decimal, precision: 8, scale: 2
    add_column :packages, :attendees_min, :integer
    add_column :packages, :attendees_max, :integer

    Package.all.each do |package|
      package.regular_price = package.price['regular']
      package.discount_price = package.price['with_discount']
      package.date_start = package.date_range['start_date']
      package.date_end = package.date_range['end_date']
      package.attendees_min = package.attendees['min']
      package.attendees_max = package.attendees['max']
      package.save!
    end
  end
end
