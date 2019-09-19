class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.string :slider_venue_ids

      t.timestamps null: false
    end
    AppSetting.create
  end
end
