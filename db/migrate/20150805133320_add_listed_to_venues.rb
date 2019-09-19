class AddListedToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :listed, :boolean, default: :false
  end
end
