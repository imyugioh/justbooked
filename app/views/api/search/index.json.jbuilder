json.menus do
  json.array!(@menus) do |menu|
    json.(menu,
        :id,
        :chef_id,
        :chef_page,
        :comments_count,
        :cuisine_type_tag_names,
        :description,
        :dietary_type_tag_names,
        :images,
        :latitude,
        :likes,
        :average_rating,
        :longitude,
        :main_image_url,
        :main_thumb_url,
        :name,
        :price,
        :slug,
        :tag_names,
        :tag_ids,
    )
    json.chef do
        json.name menu.chef.name
        json.logo_url menu.chef.profile_image_url
    end
    json.distance menu.distance_from(@search_location)
  end
end
json.chefs do
  json.array!(@chefs) do |chef|
    json.(chef,
        :id,
        :first_name,
        :last_name,
        :pre_order_notice_hour,
        :short_address,
        :pre_order_min_order_amount,
        :latitude,
        :longitude,
        :profile_image_url,
        :my_listings_path,
        :tag_names,
        :shareables,
        :individually_packaged, 
        :price_category,
        :event_types
    )
    json.distance chef.distance_from(@search_location)
  end
end
json.meta do
	json.search_location search_location
	json.search_keywords search_keywords
    json.search_lat (@search_location.nil? ? 0 : @search_location.lat)
    json.search_lng (@search_location.nil? ? 0 : @search_location.lng)
    json.current_page (@menus.is_a?(Array) ? 1 : @menus.current_page)
    json.next_page (@menus.is_a?(Array) ? 1 : @menus.current_page)
    json.prev_page (@menus.is_a?(Array) ? 1 : @menus.next_page)
    json.total_pages (@menus.is_a?(Array) ? 1 : @menus.total_pages)
    json.all_menus_count @all_menus.size
end
