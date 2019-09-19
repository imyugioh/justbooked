class MonetizeVenue < ActiveRecord::Migration
  def change
    change_column :venues, :price,  :money
  end
end
