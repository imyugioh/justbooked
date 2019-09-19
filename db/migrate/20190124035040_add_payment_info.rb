class AddPaymentInfo < ActiveRecord::Migration
  def change
    add_column :purchases, :brand, :string
    add_column :purchases, :last4, :string
  end
end
