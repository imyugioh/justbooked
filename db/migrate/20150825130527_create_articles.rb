class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.datetime :published_at
      t.belongs_to :admin_user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
