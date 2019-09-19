class AddDisplayPriorityToMenuCategories < ActiveRecord::Migration
  def change
    add_column :menu_categories, :display_priority, :integer, unique: true
  end
end
