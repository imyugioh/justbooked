class RemoveColumnsFormPackages < ActiveRecord::Migration
  def change
    remove_column :packages, :date_range
    remove_column :packages, :price
    remove_column :packages, :attendees
  end
end
