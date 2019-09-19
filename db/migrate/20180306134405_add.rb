class Add < ActiveRecord::Migration
  def change
    add_column :purchases, :chef_amount, :integer
  end
end
