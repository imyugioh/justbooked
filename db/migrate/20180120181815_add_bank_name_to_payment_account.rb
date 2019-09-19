class AddBankNameToPaymentAccount < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :dob_day, :integer
    add_column :payment_accounts, :dob_month, :integer
    add_column :payment_accounts, :dob_year, :integer
  end
end
