class AddEmailAndRedeemedFieldsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :email, :string
    add_column :venues, :redeemed, :boolean, default: true
    Venue.where(email: nil).update_all(email: 'rmagnum2002@gmail.com')
  end
end
