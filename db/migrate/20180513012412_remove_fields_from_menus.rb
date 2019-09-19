class RemoveFieldsFromMenus < ActiveRecord::Migration
  def change
    remove_column :menus, :prep_time
    remove_column :menus, :max_number_serving
  end
end
