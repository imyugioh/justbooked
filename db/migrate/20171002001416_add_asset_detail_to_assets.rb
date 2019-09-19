class AddAssetDetailToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :asset_detail, :string
  end
end
