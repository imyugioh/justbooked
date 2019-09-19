ActiveAdmin.register Menu do
  menu parent: 'Chef resource'
  reorderable
  config.sort_order = 'name_asc'

  permit_params :name, :description, :user_id, :chef_id,
    :price, :slug


  index as: :reorderable_table do
    selectable_column
    column :id
    column :name
    column :description
    column :user_id
    column :chef_id
    column :price
    column :slug
  end

  show do |menu|
    attributes_table do
      row :id
      row :listed
      row :name
      row :description
      row :user_id
      row :chef_id
      row :price
      row :slug
    end

    panel 'Assets' do
      table_for menu.assets do |a|
        column :id do |a|
          link_to a.id, admin_asset_path(a)
        end
        column :image_file_name
        column 'Image' do |a|
          link_to image_tag(a.image.url(:menu_thumb)), a.image.url, target: :blank
        end
        column 'Actions' do |a|
          link_to 'Delete image', admin_asset_path(a.id), method: :delete
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Menu Details' do
      f.input :listed
      f.input :name
      f.input :description
      f.input :user_id
      f.input :chef_id
      f.input :price
      f.input :slug
    end
    f.actions
  end

  filter :id
  filter :slug
  filter :name
  filter :description
  filter :user_id
  filter :chef_id
  filter :price

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end
  end
end
