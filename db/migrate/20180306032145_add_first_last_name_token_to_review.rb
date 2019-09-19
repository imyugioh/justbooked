class AddFirstLastNameTokenToReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :first_name, :string
  	add_column :reviews, :last_name, :string
  	add_column :reviews, :token, :string
  end
end
