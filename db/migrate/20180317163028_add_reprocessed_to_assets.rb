class AddReprocessedToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :reprocessed, :boolean, default: false
  end
end
