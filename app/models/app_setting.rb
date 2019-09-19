class AppSetting < ActiveRecord::Base
  def slider_ids
    slider_venue_ids.split(',') if slider_venue_ids
  end
end
