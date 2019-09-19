class AddGeoStatusToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :geo_code_success, :boolean, default: false
    add_column :chefs, :geo_code_retry_cnt, :integer, default: 0

    Chef.all.each do |chef|
      if chef.latitude.present? && chef.longitude.present?
        chef.update_columns(geo_code_success: true, geo_code_retry_cnt: 0)
      end
    end
  end
end
