class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.json :stripe_card
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
