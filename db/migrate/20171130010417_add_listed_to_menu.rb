class AddListedToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :listed, :boolean, default: true
  end
end
