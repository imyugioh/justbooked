class AddVenuesLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :venues_limit, :integer, default: 1
  end
end
