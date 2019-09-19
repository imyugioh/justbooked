class AddLocationToMenu < ActiveRecord::Migration
  def change
  	add_column :menus, :latitude, :decimal, precision: 9, scale: 6
		add_column :menus, :longitude, :decimal, precision: 9, scale: 6


		Chef.all.each do |chef|
			if chef.latitude.present? && chef.longitude.present?
				chef.menus.update_all(latitude: chef.latitude, longitude: chef.longitude)
			end
		end
  end
end