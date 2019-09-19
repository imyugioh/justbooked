class AddTokenToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :token, :string
    Venue.all.each(&:regenerate_token)
  end
end
