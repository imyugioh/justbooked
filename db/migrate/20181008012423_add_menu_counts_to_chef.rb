class AddMenuCountsToChef < ActiveRecord::Migration
  def change
    add_column :chefs, :menus_count, :integer, default: 0

    Chef.all.each do |chef|
      menus_cnt = Menu.where(chef_id: chef.id).count
      execute "UPDATE chefs set menus_count = #{menus_cnt} where id = #{chef.id}"
    end
  end
end
