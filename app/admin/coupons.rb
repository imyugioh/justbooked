ActiveAdmin.register Coupon do
  menu parent: 'Admin resource'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :comment, :on, :comment
permit_params :name, :card_token, :customer_id, :discount, :start_date, :end_date, :expired, :limit, :on, :coupon
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  form do |f|
    # f.input :start_at, as: :date_time_picker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }
    # f.input :end_at,   as: :date_time_picker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
    f.inputs 'Coupon Details' do
      f.input :name
      f.input :card_token
      f.input :customer_id
      f.input :discount
      f.input :start_date, as: :date_time_picker, datepicker_options: { timepicker: false, }
      f.input :end_date, as: :date_time_picker, datepicker_options: { timepicker: false, }
      f.input :expired
      f.input :limit
    end

    f.actions
  end
end
