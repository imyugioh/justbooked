class AddAssetsCountToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :assets_count, :integer
    Venue.find_each do |venue|
      venue.assets_count = venue.assets.count
      venue.save
    end
  end
end
