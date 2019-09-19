class AddTrasactionFeeToChef < ActiveRecord::Migration
  def change
    add_column :chefs, :transaction_fee, :integer, :default => 20
  end
end
