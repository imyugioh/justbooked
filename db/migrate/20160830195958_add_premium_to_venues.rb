class AddPremiumToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :premium, :boolean
  end
end
