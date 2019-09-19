class AddMenuCategoryIdToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :menu_category_id, :integer
  end
end
