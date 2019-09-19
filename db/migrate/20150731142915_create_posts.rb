class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.belongs_to :user, index: true, foreign_key: true
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
