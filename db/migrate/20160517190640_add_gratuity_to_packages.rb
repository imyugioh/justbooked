class AddGratuityToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :gratuity, :integer
  end
end
