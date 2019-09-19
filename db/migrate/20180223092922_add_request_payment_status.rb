class AddRequestPaymentStatus < ActiveRecord::Migration
  def change
  	add_column :purchases, :request_status, :string, default: 'New'
  	add_column :purchases, :payment_status, :string
  end
end
