class AddPackagesCountToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :packages_count, :integer
    Venue.find_each { |venue| Venue.reset_counters(venue.id, :packages) }
  end
end
