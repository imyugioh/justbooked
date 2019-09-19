class AddTokenToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :token, :string
  end
end
