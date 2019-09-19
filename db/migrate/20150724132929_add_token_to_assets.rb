class AddTokenToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :token, :string
  end
end
