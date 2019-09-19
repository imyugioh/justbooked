class Remove < ActiveRecord::Migration
  def change
    remove_column :users, :venues_limit
  end
end
