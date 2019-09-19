class AddPublishedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :published_at, :datetime
    Comment.all.each do |comment|
      comment.update_attributes(published_at: comment.created_at)
    end
  end
end
