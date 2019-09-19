ActiveAdmin.register AppSetting do
  menu parent: 'Admin resource'
  actions :index, :show, :edit, :update
  permit_params :slider_venue_ids, :default_booking_type, :on, :app_setting
end
