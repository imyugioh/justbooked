class GeoCoder < ActiveJob::Base
  queue_as :default

  def perform(session_id, ip_address)
    begin
      puts ">>>>>>>> getting geo ip address"
      geo_info = nil

      # For local testing
      if ip_address == "127.0.0.1" || ip_address == 'localhost' || ip_address == '::1'
        ip_address = '99.252.136.85'
      end

      if ($redis.keys.include?(session_id))
        geo_info = JSON.parse($redis.get(session_id))
        created_at = geo_info['created_at']
        if (Time.zone.now.to_i - created_at > (24 * 60 * 60))
          geo_info = nil
        end
      end

      if geo_info.nil?
        uri = URI("http://freegeoip.net/json/#{ip_address}")
        response = Net::HTTP.get(uri)
        result = JSON.parse(response)
        ap result
        geo_info = {lat: result['latitude'], lng: result['longitude'], created_at: Time.zone.now.to_i}.to_json
        $redis.set(session_id, geo_info)
        puts "-------------------------------------------------------- ip: #{ip_address} session_id: #{session_id} geo_info: #{geo_info}"
      else
        puts "....................... fetched cached info #{geo_info}"
      end
    rescue JSON::ParserError => e
      puts ">>>>>>>>>>>>> not a valid response"
    end
  end


end