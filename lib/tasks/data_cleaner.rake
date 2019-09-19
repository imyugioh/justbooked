namespace :data do
  desc "Geocode chef and menu data"
  task clean_geo_code: :environment do
    puts ">>> start geocoding for chefs"
    success_cnt = 0
    failed_cnt = 0

    candidate = Chef.where(geo_code_success: false, latitude: nil, longitude: nil).where("geo_code_retry_cnt < ?", Chef::MAX_GEO_CODE_TRY_CNT)
    total_cnt = candidate.count

    candidate.each do |chef|
      if chef.run_geo_code
        success_cnt += 1
        puts ">>> geocoding success for chef #{chef.first_name} (#{chef.id})"
      else
        failed_cnt += 1
        puts ">>> geocoding failed for chef #{chef.first_name} (#{chef.id})"
      end
    end

    puts ">>> finished geocoding. Total #{total_cnt} chefs. #{success_cnt} succeed, #{failed_cnt} failed"
  end


  # task check_image_exist: :environment do
  #   Chef.all.each do |chef|
  #     # profile_image = chef.profile_image_url

  #     # uri = URI(profile_image)

  #     # request = Net::HTTP.new uri.host
  #     # response= request.request_head uri.path
  #     # if response.code.to_i != 200
  #     #   puts "asset id: #{chef.profile_asset_id} #{profile_image} DOES NOT exist"
  #     # end

  #     if (chef.header_asset_id) 
  #       puts "chef #{chef.id}  asset id: #{chef.header_asset_id}"
  #       header_image = chef.header_asset.image.url(:chef_banner)

  #       uri = URI(header_image)

  #       request = Net::HTTP.new uri.host
  #       response= request.request_head uri.path
  #       if response.code.to_i != 200
  #         puts "asset id: #{chef.header_asset_id} #{header_image} DOES NOT exist"
  #       end
  #   end

  # end

  task regenerate_asset_images: :environment do

    # First replace default asset files
    if default_profile = Asset.where(asset_detail: 'chef_profile').first
      default_profile.update_attribute(:asset_detail, 'default_chef_profile')
    end

    if default_header = Asset.where(asset_detail: 'chef_header').first
      default_header.update_attribute(:asset_detail, 'default_chef_header')
    end


    puts ">>> Processing asset images"
    Asset.where(reprocessed: false).each do |asset| 
      if asset.image
        puts ">>> processing asset #{asset.id} #{asset.image.url}"
        if asset.image.reprocess! 
          asset.update_attribute(:reprocessed, true)
        else
          puts ">>> something wrong with asset #{asset.id} #{asset.image.url}"
        end
      end
    end

  end
end
