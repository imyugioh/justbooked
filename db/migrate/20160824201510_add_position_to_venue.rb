class AddPositionToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :position, :integer

    Venue.all.each do |venue|
      venue.position = venue.id
      venue.save(validate: false)
    end
  end
end
