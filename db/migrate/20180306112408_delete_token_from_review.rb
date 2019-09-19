class DeleteTokenFromReview < ActiveRecord::Migration
  def change
  	remove_column :reviews, :token
  end
end
