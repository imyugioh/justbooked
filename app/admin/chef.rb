ActiveAdmin.register Chef do
  menu parent: 'Chef resource'
  reorderable
  config.sort_order = 'first_name_asc'

  permit_params :certified, :first_name, :last_name, :user_id,
                :id, :email, :phone, :address1, :address2,
                :city, :state, :zip, :certified, :delivery_fee,
                :free_delivery_min_order_amount, :onsite_cooking_available,
                :pickup_available, :min_fee_for_onsite_cooking,
                :transaction_fee, :listed


  index as: :reorderable_table do
    selectable_column
    column :id
    column :certified
    column :documents_uploaded
    column :first_name
    column :last_name
    column :user_id
    column :address1
    column :city
    actions
  end

  show do |menu|
    attributes_table do
      row :id
      row :listed
      row :onsite_cooking_available
      row :pickup_available

      row "Profle Image" do |chef|
        image_tag(chef.profile_image_url)
      end
      row "Main Image" do |chef|
        image_tag(chef.main_image_url)
      end
      row :first_name
      row :last_name
      row :user_id
      row :address1
      row :city
      row :transaction_fee
      row :delivery_fee
      row :free_delivery_min_order_amount
      row :min_fee_for_onsite_cooking


      row :certified
      row "Personal ID" do |chef|
        if chef.personal_identification 
          link_to "Personal Document", chef.personal_identification.url
        else
          ""
        end
      end
      row "Food Handler Certification" do |chef|
        if chef.food_handler_certification 
          link_to "Food Handler Document", chef.food_handler_certification.url
        else
          ""
        end
      end

    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Chef Details' do
      f.input :listed
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :user_id
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state
      f.input :zip
      f.input :transaction_fee
      f.input :certified
      f.input :onsite_cooking_available
      f.input :pickup_available
      f.input :delivery_fee
      f.input :free_delivery_min_order_amount
      f.input :min_fee_for_onsite_cooking
    end
    f.actions
  end

  filter :id
  filter :slug
  filter :certified
  filter :first_name
  filter :last_name
  filter :user_id
  filter :address1
  filter :city

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end
  end
end
