class CreateChefs < ActiveRecord::Migration
  def change
    create_table :chefs do |t|
      t.string :first_name
      t.string :last_name
      t.integer :user_id
      t.integer :street_number
      t.string :street_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :neighborhood
      t.string :state
      t.string :state_code
      t.string :zip
      t.string :country
      t.string :country_code
      t.string :website
      t.string :slug
      t.string :social_links
      t.string :email
      t.string :phone
      t.timestamp :dob
      t.text :about
      t.integer :max_delivery_distance
      t.integer :min_order_amount
      t.string :sun_start
      t.string :sun_end
      t.string :mon_start
      t.string :mon_end
      t.string :tue_start
      t.string :tue_end
      t.string :wed_start
      t.string :wed_end
      t.string :thr_start
      t.string :thr_end
      t.string :fri_start
      t.string :fri_end
      t.string :sat_start
      t.string :sat_end
      t.integer :profile_asset_id
      t.integer :header_asset_id
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.jsonb   :geocode_result
      t.integer :asset_count
      t.integer  :position

      t.timestamps null: false
    end
  end
end