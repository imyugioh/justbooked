class AddPrepTimeToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :prep_time, :integer
  end
end
