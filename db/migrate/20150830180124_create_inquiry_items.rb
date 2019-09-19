class CreateInquiryItems < ActiveRecord::Migration
  def change
    create_table :inquiry_items do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :venue, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
