ActiveAdmin.register Review do
  menu parent: 'User resource'
  reorderable
  config.sort_order = 'menu_id_asc'

  permit_params :id, :user_id, :chef_id, :menu_id, :rating, 
                :feedback, :purchase_id, :first_name, :last_name


  index as: :reorderable_table do
    selectable_column
    column :id

    column "Menu" do |review|
      if review.menu
        link_to "#{review.menu.name} (#{review.menu.id})", review.chef
      end
    end

    column "User" do |review|
      if review.user
        "#{review.user.full_name} (#{review.user.id})"
      else
        ""
      end
    end
    column "Chef" do |review|
      if review.chef
        "#{review.chef.full_name} (#{review.chef.id})"
      end
    end
    column :purchase_id
    column :rating
    column :first_name
    actions
  end

  show do |review|
    attributes_table do
      row :id

      row "Menu" do |review|
        if review.menu
          link_to "#{review.menu.name} (#{review.menu.id})", review.chef
        end
      end
      row "User" do |review|
        if review.user
          "#{review.user.full_name} (#{review.user.id})"
        else
          ""
        end
      end
      row "Chef" do |review|
        if review.chef
          "#{review.chef.full_name} (#{review.chef.id})"
        end
      end

      row :rating
      row :first_name
      row :last_name
      row :feedback
    end

    active_admin_comments
  end

  form do |f|
    menu_options = Menu.where("chef_id is not null").order(:chef_id).map{|m| ["#{m.name} (chef_id: #{m.chef.id})", m.id] if m.chef.present?}.compact
    f.inputs 'Chef Details' do
      f.input :user_id, :label => 'User', :as => :select, :collection => User.all.order(:first_name).map{|u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id]}
      f.input :chef_id, :label => 'Chef', :as => :select, :collection => Chef.all.order(:first_name).map{|c| ["#{c.first_name} #{c.last_name} (chef_id: #{c.id})", c.id]}
      f.input :menu_id, :label => 'Menu', :as => :select, :collection => menu_options

      f.input :rating
      f.input :first_name
      f.input :last_name
      f.input :feedback
    end
    f.actions
  end

  filter :user_id
  filter :chef_id
  filter :menu_id
  filter :rating
  filter :first_name
  filter :last_name

  controller do
    def find_resource
      scoped_collection.where(id: params[:id]).first!
    end

    def scoped_collection
      Review.includes([:user, :chef, :menu])
    end
  end


end
