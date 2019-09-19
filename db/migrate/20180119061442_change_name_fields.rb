class ChangeNameFields < ActiveRecord::Migration
  def change
    remove_column :payment_accounts, :name
    add_column :payment_accounts, :first_name, :string
    add_column :payment_accounts, :last_name, :string
  end
end
