class AddPurchaseId < ActiveRecord::Migration
  def change
  	add_column :reviews, :purchase_id, :integer
  end
end
