class AddMenuTypeToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :menu_type, :string, default: 'single'
  end
end
