class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.belongs_to :venue, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.jsonb :date_range, default: {}
      t.jsonb :price, default: {}
      t.jsonb :attendees, default: {}
      t.jsonb :weekdays, default: {}

      t.timestamps null: false
    end
  end
end
