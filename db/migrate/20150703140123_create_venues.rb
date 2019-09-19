class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :title
      t.text :description
      t.references :user
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :street_address
      t.string :street_number
      t.string :street_name
      t.string :city
      t.string :state
      t.string :state_code
      t.string :state_name
      t.string :zip
      t.string :country_code
      t.string :provider
      t.string :neighborhood
      t.string :district
      t.string :country
      t.string :accuracy
      t.string :website
      t.integer :price
      t.integer :capacity

      t.timestamps null: false
    end
  end
end
