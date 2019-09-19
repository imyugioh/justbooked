class AddStripResponseToPaymentAccount < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :stripe_response, :jsonb
  end
end
