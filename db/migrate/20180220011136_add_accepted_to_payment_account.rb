class AddAcceptedToPaymentAccount < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :stripe_accepted, :boolean, default: false
  end
end
