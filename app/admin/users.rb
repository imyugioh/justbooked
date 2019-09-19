ActiveAdmin.register User do
  menu parent: 'User resource'
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :first_name, :last_name, :email, :phone, :on, :user
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  index do
    selectable_column
    column :id
    column :email
    column :first_name
    column :last_name
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :email
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :confirmation_token
      row :confirmed_at
      row :confirmation_sent_at
      row :unconfirmed_email
      row :created_at
      row :updated_at
      row :newsletter
      row :token
    end

    # panel "Venues (#{user.venues.size})" do
    #   table_for user.venues do |v|
    #     column :id
    #     column :name do |v|
    #       link_to v.name, admin_venue_path(v)
    #     end
    #     column :email
    #     column :country_code
    #     column :state
    #     column :city
    #     column :assets_count do |v|
    #       v.assets.size
    #     end
    #     # column :requests_count do |v|
    #     #   v.requests.size
    #     # end
    #     column :reviews_count do |v|
    #       v.comments.size
    #     end
    #     column :created_at
    #   end
    # end

    active_admin_comments
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
    end

    f.actions
  end

  filter :first_name
  filter :last_name
  filter :email
end
