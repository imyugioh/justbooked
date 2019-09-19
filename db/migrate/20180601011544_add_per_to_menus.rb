class AddPerToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :per, :string, default: 'platter'
  end
end
