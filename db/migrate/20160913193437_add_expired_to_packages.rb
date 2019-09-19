class AddExpiredToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :expired, :boolean, default: false
  end
end
