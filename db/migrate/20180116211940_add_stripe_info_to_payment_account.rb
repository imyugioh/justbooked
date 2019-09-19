class AddStripeInfoToPaymentAccount < ActiveRecord::Migration
  def change
    add_column  :payment_accounts, :stripe_account, :string
    add_column :payment_accounts, :stripe_secret, :string
    add_column :payment_accounts, :stripe_publishable, :string
    add_column :payment_accounts, :stripe_validated, :boolean, default: false

    add_index  :payment_accounts, :stripe_account
  end
end