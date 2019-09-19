module ApplicationHelper

  include ActionView::Helpers::NumberHelper

  def body_class
    case controller_name
    when 'welcome'
      "homepage"
    when 'listings'
      if action_name == 'index'
        'listing'
      else
        'detail_view'
      end
    when 'chefs'
      'detail_view'
    else
      "UNKNOWN"
    end
  end

  def current_class?(test_path) 
    if request.path == test_path
      return 'active nav-link sidenav-link'
    else
      return 'nav-link sidenav-link'
    end
  end

  def random_slide
    id = [1, 2, 3, 4, 5, 6].sample
    asset_url "slides/#{id}.jpg"
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end

  def normal_time(time)
    time.strftime('%A, %B %d, %Y at %l:%M %p')
  end

  def custom_date(date)
    date.strftime("%A, %b #{date.day.ordinalize}")
  end

  def main_search_bg
    @venue.present? ? @venue.assets.sample.image.url :  asset_url('main-search_bg.jpg')
  end

  def content_short
    simple_format (ActionView::Base.full_sanitizer.sanitize(@article.content).truncate(500, omission: '...'))
  end

  # used in booking notification mailer
  def link_to_booking text=nil
    text = text || 'Click here to Accept/Decline request'
    # path =  @venue.redeemed ? request_url(@request) : redeem_venue_url(@venue.token, from: 'request_email')
    path = booking_url(@booking.token)
    link_to text, path
  end

  def overflow_hidden
    "style='overflow: hidden;'".html_safe unless cookies[:show_welcome].present?
  end

  def menu_price(price)
    "$#{number_with_precision(price, :precision => 2)}"
  end

  def menu_count(menu_category_id)
    puts menu_category_id
    if menu_category_id != ''
      Menu.where(menu_category_id: menu_category_id).count
    else
      0
    end
  end


  def price_filters
    [
      ['0,25', 'Under $25'],
      ['25,45', '$25 - $45'],
      ['46,60', '$46 - $60'],
      ['60,1000', '$60+']
    ]
  end

  def price_description(menu)
    if menu.menu_type == 'single'
      'price for this item'
    else
      'price for each item'
    end
  end

  def hour_filters
    hours = []
    numbers = [1,2,3,4,5,6,7,8,9,10,12,18,24,30,36,42,48,72]
    numbers.each do |hour|
      hours << [pluralize(hour, 'hour') + " notice", hour]
    end
    hours
  end

  def amount_filters
    amounts = []
    dollars = [10,15,20,25,30,35,40,45,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400]
    dollars.each do |dollar|
      af = dollar.to_f
      amounts << ["$#{af}", af]
    end
    amounts
  end

  def distance_filters
    distances = [
      ["2 km", 2],
      ["4 km", 4],
      ["6 km", 6],
      ["10 km", 10],
      ["15 km", 15],
      ["20 km", 20],
      ["30 km", 30],
      ["50 km", 50],
      ["100 km", 100],
      ["200 km", 200]
    ]
  end


  def cuisine_type_filters
    Menu.popular_cuisine_types
  end

  def dietary_type_filters
    Menu.popular_dietary_types
  end

  def cuisine_types(menu) # used for menu & chef cuisine type
    predefined_tags = Tag.select(:id).where(tag_type: 'cuisine_type').order('taggings_count desc, name asc').limit(20)
    menu_tags = menu.cuisine_type.pluck(:id)
    Tag.where(id: [predefined_tags, menu_tags].flatten.uniq).order("LOWER(name) asc")
  end

  def dietary_types(menu)
    predefined_tags = Tag.select(:id).where(tag_type: 'dietary_type').order('taggings_count desc, name asc').limit(20)
    menu_tags = menu.dietary_type.pluck(:id)
    Tag.where(id: [predefined_tags, menu_tags].flatten.uniq).order("LOWER(name) asc")
  end

  def has_this_cuisine_type?(menu, tag) # used for menu & chef cuisine type checking ...
    menu.cuisine_type.pluck(:name).include?(tag) ? 'checked' : nil
  end

  def has_this_dietary_type?(menu, tag)
    menu.dietary_type.pluck(:name).include?(tag) ? 'checked' : nil
  end

  def has_this_event_type?(chef, event_type)
    chef.event_types.include?(event_type) ? 'checked' : nil
  end

  def has_this_order_selection?(menu, item)
    menu.menu_items.pluck(:name).include?(item) ? 'checked' : nil
  end

  def has_this_add_ons?(menu, addon)
    menu.addons.pluck(:name).include?(addon) ? 'checked' : nil
  end

  def ip_geo_coding(session_id, ip_address)
    geo_info = nil

    begin

      # For local testing
      if ip_address == "127.0.0.1" || ip_address == 'localhost' || ip_address == '::1'
        ip_address = '99.252.136.85'
      end

      uri = URI("http://freegeoip.net/json/#{ip_address}")
      response = Net::HTTP.get(uri)
      result = JSON.parse(response)
      ap result
      geo_info = {lat: result['latitude'], lng: result['longitude'], created_at: Time.zone.now.to_i}.to_json
      $redis.set(session_id, geo_info)
      # puts "-------------------------------------------------------- ip: #{ip_address} session_id: #{session_id} geo_info: #{geo_info}"

    rescue JSON::ParserError => e
      puts ">>>>>>>>>>>>> not a valid response"
    end

    geo_info
  end

  def get_user_location
    session_id = request.session_options[:id]
    ip_address = request.remote_ip

    if $redis.keys.include?(session_id)
      geo_info = JSON.parse($redis.get(session_id))
    else
      geo_info = ip_geo_coding(session_id, ip_address)
    end
  end

  def flash_class(level)
    alert_class = 
      case level
          when 'notice' then "alert alert-info fade"
          when 'success' then "alert alert-success fade"
          when 'error' then "alert alert-error"
          when 'alert' then "alert alert-error fade"
      end
  end

  def error_msg_to_id(error_message)
    error_message.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '_')
  end

  def replace_url_to_link(str)
    str.gsub!(/(http:\/\/\S+)/, '<a href="\1">\1</a>')
  end

  def delivery_type(type)
    case type
    when 'delivery' # delivery
      'Delivery'
    when 'pickup' # pickup
      'Pick Up'
    else # onsite-cooking
      'Onsite cooking'
    end
  end

end
