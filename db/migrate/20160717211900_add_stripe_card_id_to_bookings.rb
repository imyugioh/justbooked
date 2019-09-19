class AddStripeCardIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :stripe_card_id, :string
  end
end
