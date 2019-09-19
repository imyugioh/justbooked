class ChangeCapacityFieldAndCapacityMaxToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :capacity_min, :integer
    add_column :venues, :capacity_max, :integer
  end
end
