class AddAutoAcceptLimitToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :auto_accept_limit, :integer
  end
end
