class ChangeReviewFeedbackColumn < ActiveRecord::Migration
  def change
  	change_column :reviews, :feedback, :text
  end
end
