namespace :data do

  # e.g) rake data:duplicate_chef[3]
  desc "duplicate the chef_data with ID"
  task :duplicate_chef, [:id] => [:environment] do |task, args|

	puts '.........duplicating chef.........'

  chef = Chef.find(args[:id])
	user = chef.user

	puts ">> started copying chef #{chef.id}"
  new_user = User.new(user.attributes.except("id", "confirmation_token", "created_at", "updated_at"))

  new_email = unique_email(user)
  if new_email.nil?
    puts "!!!!!!!!! can not copy user"
    exit
  end

	new_user.email =  new_email
	new_user.password = "justbooked"
	new_user.password_confirmation = "justbooked"
	if new_user.save
    puts ">> new user #{new_user.id} is created"
    puts ">> ID: #{new_user.email} PW: justbooked"
	else
	  puts new_user.errors.to_a
	  exit
	end
 
  new_chef_slug = unique_chef_slug(chef.slug)
	new_chef = Chef.new(chef.attributes.except("id", "slug", "created_at", "updated_at").merge(user_id: new_user.id, slug: new_chef_slug))
	if new_chef.save
	  puts ">> new chef #{new_chef.id} is created. Slig: #{new_chef_slug}"
	else
	  puts new_chef.errors.to_a
	  exit
	end

	new_chef_assets = []
    chef.assets.each do |asset|
      puts "copy chef asset #{asset.id}..."
      new_chef_asset = Asset.new(asset.attributes.except("id", "created_at", "assetable_id", "updated_at").merge(assetable_id: new_chef.id))
      if new_chef_asset.save
        puts ">> new chef asset #{new_chef_asset.id} is created"
        new_chef_assets << new_chef_asset
      else
        puts new_chef_asset.errors.to_a
        exit
      end
    end

    new_chef_docs = []
    chef.documents.each do |docu|
      puts "copy chef document #{docu.id}..."
      new_chef_doc = Document.new(docu.attributes.except("id", "created_at", "assetable_id", "updated_at").merge(assetable_id: new_chef.id))
      if new_chef_doc.save
        puts ">> new chef document #{new_chef_doc.id} is created"
        new_chef_docs << new_chef_doc
      else
        puts new_chef_docs.errors.to_a
        exit
      end
    end

    new_chef_categories = []
    chef.menu_categories.each do |category|
    	new_category = MenuCategory.new(category.attributes.except("id", "created_at", "updated_at", "chef_id").merge(chef_id: new_chef.id))
    	if new_category.save
    		puts ">> new chef category #{new_category.id} is created"
    		new_chef_categories << new_category
    	else
    		puts new_chef_categories.errors.to_a
    		exit
    	end
    end

   	chef.menus.each do |menu|
        # first create new assets
        new_assets = []
        puts ">>>> #{menu.cuisine_type} #{menu.order_selection} #{menu.add_ons}"
        menu.assets.each do |asset|
          puts "copy #{asset.id}..."
          new_asset = Asset.new(asset.attributes.except("id", "created_at", "updated_at").merge(assetable_id: new_chef.id))
          if new_asset.save
            puts ">> new menu asset #{new_asset.id} is created"
            new_assets << new_asset
          else
            puts new_asset.errors.to_a
            exit
          end
        end

        new_menu_slug = unique_menu_slug(menu.slug)
        menu_params = menu.attributes.except("id", "user_id", "slug", "chef_id", "created_at", "updated_at").merge(chef_id: new_chef.id, user_id: new_user.id, slug: new_menu_slug)
        
        new_menu = Menu.create(menu_params)
        new_menu.set_tag_list_on(:cuisine_type, menu.cuisine_type)

        if new_menu.save
          puts ">> new menu #{new_menu.id} is created"
        else
          puts new_menu.errors.to_a
          exit
        end

        ActsAsTaggableOn::Tagging.where(taggable_type: 'Menu', taggable_id: menu.id).each do |t|
        	tagging = ActsAsTaggableOn::Tagging.new(t.attributes.except("id", "tag_id", "created_at").merge(taggable_id: new_menu.id))
        	puts tagging
        	if tagging.save
        		puts ">> tagging is created"
        	else
        		puts tagging.errors.to_a
        	end
        end

        # Assign new menu to the asset
        # new_assets.each do |asset|
        #   asset.udpate_attribute(:assetable_id, new_menu.id)
        # end
  	end

  end


  def unique_email(user)
    email = nil
    1.upto(100) do |n|
      fixed_num = format('%03d', n)
      new_email = "#{user.email}-#{fixed_num}"
      searching_user = User.find_by_email(new_email)
      if searching_user.nil?
        email = new_email
        break
      end
    end
    email
  end

  def unique_chef_slug(slug)
    new_slug = nil
    1.upto(100) do |n|
      new_slug = "#{slug}-#{n}"
      chef = Chef.find_by_slug(new_slug)
      if chef.nil?
        break
      end
    end
    new_slug
  end

  def unique_menu_slug(slug)
    new_slug = nil
    1.upto(100) do |n|
      new_slug = "#{slug}-#{n}"
      menu = Menu.find_by_slug(new_slug)
      if menu.nil?
        break
      end
    end
    new_slug
  end


end