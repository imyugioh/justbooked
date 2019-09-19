class AddPopularToVenues < ActiveRecord::Migration
  def change
      add_column :venues, :popular, :boolean
  end
end
