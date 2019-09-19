include Geokit::Geocoders

class Chef < ActiveRecord::Base
  # include PgSearch
  extend FriendlyId

  serialize :event_types, Array
  has_one :payment_account

  DEFAULT_START = 1030
  DEFAULT_END = 2000
  MAX_GEO_CODE_TRY_CNT = 3
  PRICE_CATEGORIES = %i[low medium high].freeze
  EVENT_TYPES = ['Lunch & Learn', 'Executive Meeting', 'Breakfast', 'Dinner', 'Special Occasion', 'Other'].freeze

  before_validation :strip_whitespace

  enum price_category: PRICE_CATEGORIES
  # pg_search_scope :search_by_state_code, against: :state_code
  # pg_search_scope :search_by_state_name, against: :state_name
  # pg_search_scope :search_by_city, against: :city
  has_many :assets, as: :assetable, dependent: :destroy
  has_many :documents, as: :assetable, dependent: :destroy

  has_many :menus, -> { order(menu_category_id: :asc)}
  has_many :menu_categories, -> { order(id: :asc)}, :dependent => :delete_all
  has_one :payment_account
  belongs_to :user

  accepts_nested_attributes_for :menu_categories, allow_destroy: true

  friendly_id :name, use: :slugged

  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  acts_as_taggable_on :cuisine_type

  after_initialize :default_values
  before_save :update_assets_count
  after_save :geocode_address
  after_save :update_menu_locations

  validates :user_id, presence: true
  validates :first_name, :last_name, :address1, presence: true
  validates :email, :city, :state, :country, presence: true
  validates :dob, :phone, :transaction_fee, :about, presence: true
  
  validates :max_delivery_distance, presence: true
  validates :pre_order_notice_hour, :pre_order_min_order_amount, presence: true
  # validates :free_delivery_min_order_amount, :delivery_fee, presence: true

  validates :onsite_cooking_available, inclusion: { in: [ true, false ] }
  validates :pickup_available, inclusion: { in: [ true, false ] }

  validates_format_of :email, with: Devise::email_regexp
  validates_length_of :about, in: 5..1500
  
  scope :available_today, -> {
    t = Date.today.strftime('%a').downcase
    start_work = "#{t}_start"
    end_work = "#{t}_end"
    now_time = Time.zone.now.hour * 100 + Time.zone.now.min
    where("#{start_work} <= ? AND #{end_work} >= ?", now_time, now_time)
  }

  scope :within_location, -> (search_location, distance) {
    distance = Rails.configuration.x.default_search_distance unless distance
    within(distance, :units => :kms, :origin => search_location).by_distance(origin: search_location)
  }

  def trim num
    num == num.to_i ? num.to_i : num
  end

  def self.tag(tag)
    if tag
      tagged_with(tag, any: true)
    else
      all
    end
  end

  def cuisine_type_tag_names
    cuisine_type.select(:name).pluck(:name)
  end

  def tag_names
    [cuisine_type_tag_names].flatten.sort
  end

  def self.schedule_day_names
    full_names = []

    day_names = I18n.t('date.abbr_day_names').map(&:downcase)    
    day_names.each do |name|
      full_names << "#{name}_start"
      full_names << "#{name}_end"
    end  
    full_names
  end  

  def full_name
    [first_name, last_name].join(' ')
  end

  def page_title
    s = "#{name.strip}, Address: #{full_address}"
    s = s + " Phone: #{phone}" if phone.presence
  end

  def page_description
    s = about if about.presence
    if cuisine_type_tag_names.presence
      s = s + "serving #{cuisine_type_tag_names}"
    end
    s
  end

  def default_values
    self.country ||= "Canada"
    self.country_code ||= "CA"

    self.max_delivery_distance ||= 5
    self.pre_order_min_order_amount ||= 30

    self.profile_asset_id ||= Asset.default_chef_profile.id
    self.header_asset_id ||= Asset.default_chef_header.id
  end

  def has_profile_image?
    !profile_asset_id.nil? && profile_asset_id != Asset.default_chef_profile.id
  end

  def has_header_image?
    !header_asset_id.nil? && header_asset_id != Asset.default_chef_header.id
  end

  def name
    "#{first_name} #{last_name}"
  end

  def short_address
    "#{street_number} #{street_name} #{city}"
  end

  def full_address
    address_part1 = self.address1
    if self.address2 && self.address2 != ""
      address_part1 = [self.address1, self.address2].join(', ')
    end
    [address_part1, self.city, self.state, self.country, self.zip].join(', ')
  end

  def my_listings_path
    "/chefs/#{friendly_id}"
  end

  def owns?(menu)
    menus.select(:id).pluck(:id).include?(menu.id)
  end

  def business_name
    n = "#{first_name} #{last_name}"
    if payment_account
      n = payment_account.business_name      
    end
    n
  end

  def assign_assets(ids)
    return if assets.count >= 6
    Asset.where(
      assetable_type: 'Menu', id: ids
    ).update_all(assetable_id: id)
  end

  def main_image_url
    if header_asset
      header_asset.image.url(:chef_banner)
    else
      "/assets/images/detail-top-bg.png"
    end
  end
  
  def profile_image_url
    if profile_asset
      profile_asset.image.url(:chef_profile)
    else
      Asset.default_chef_profile.image.url(:chef_profile)
    end
  end


  def main_thumb_url
    return '' unless assets.any?
    assets.first.image.url(:chef_profile)
  end

  def profile_asset
    Asset.find(profile_asset_id) rescue nil
  end

  def personal_identification
    documents.where(document_detail: :personal_identification).first rescue nil
  end

  def food_handler_certification
    documents.where(document_detail: :food_handler_certification).first rescue nil
  end



  def replace_profile_asset(params)
    if  params['profile_image']
      profile_asset.destroy if (profile_asset && profile_asset.id != Asset.default_chef_profile.id)
      profile = Asset.create(image: params['profile_image'], token: params['token'], assetable_type: 'Chef', assetable_id: id, asset_detail: 'profile')
    end
    profile
  end

  def header_asset
    Asset.find(header_asset_id) rescue nil
  end

  def certified?
    certified
  end

  def documents_uploaded
    personal_identification.present? && food_handler_certification.present?
  end


  def replace_header_asset(params)
    if params['header_image']
      header_asset.destroy if (header_asset  && header_asset.id != Asset.default_chef_header.id)
      header = Asset.create(image: params['header_image'], token: params['token'], assetable_type: 'Chef', assetable_id: id, asset_detail: 'header')
    end
    header
  end


  def replace_personal_identification(params)
    if params['personal_identification']
      personal_identification.destroy if personal_identification
      personal_identification = Document.create(document: params['personal_identification'], token: params['token'], assetable_type: 'Chef', assetable_id: id, document_detail: 'personal_identification')
    end
    personal_identification
  end

  def replace_food_handler_certification(params)
    if params['food_handler_certification']
      food_handler_certification.destroy if food_handler_certification
      food_handler_certification = Document.create(document: params['food_handler_certification'], token: params['token'], assetable_type: 'Chef', assetable_id: id, document_detail: 'food_handler_certification')
    end
    food_handler_certification
  end

  def schedule_day_names
    day_names = I18n.t('date.abbr_day_names').map(&:downcase)    
    idx = Date::DAYNAMES.index(Date.today.strftime("%A"))
    abbr_name = day_names[idx]
    start_time = send("#{abbr_name}_start").insert(2, ':')
    end_time = send("#{abbr_name}_end").insert(2, ':') 
    "#{start_time} - #{end_time}"
  end


  def serving_time
    day_names = I18n.t('date.abbr_day_names').map(&:downcase)    
    idx = Date::DAYNAMES.index(Date.today.strftime("%A"))
    abbr_name = day_names[idx]
    start_time = send("#{abbr_name}_start").insert(2, ':')
    end_time = send("#{abbr_name}_end").insert(2, ':') 
    "#{start_time} - #{end_time}"
  end


  def geocode_address
    return if address1.nil?

    if address1_changed? || city_changed? || state_changed? || zip_changed? || country_changed?
      run_geo_code
    else
      puts ">> address was not changed. geocoding skipped"
    end
  end


  def run_geo_code
    result = false
    begin
      address = "#{address1}, #{city}, #{state}, #{zip}, #{country}"
      loc = MultiGeocoder.geocode(address)
      unless loc.success
        puts ">>> can not geocode #{address}"
      end

      geocode_result = {
        latitude: loc.latitude,
        longitude: loc.longitude,
        street_number: loc.street_number,
        street_name: loc.street_name,
        city: loc.city,
        state: loc.state,
        state_code: loc.state_code,
        state_name: loc.state_name,
        zip: loc.zip,
        country_code: loc.country_code,
        provider: loc.provider,
        neighborhood: loc.neighborhood,
        district: loc.district,
        country: loc.country,
        accuracy: loc.accuracy
      }.to_json

      ap geocode_result

      update_columns(
        latitude: loc.latitude,
        longitude: loc.longitude,
        geocode_result: geocode_result,
        street_number: loc.street_number,
        street_name: loc.street_name,
        country_code: loc.country_code,
        state_code: loc.state_code
      )

      update_menu_locations
      result = true
    rescue => error
      puts error.inspect
    end
    result
  end



  def custom_geo_code(address)
    begin
      if address
        loc = MultiGeocoder.geocode(address)
        unless loc.success
          puts ">>> can not geocode #{address}"
          return 
        end

        geocode_result = {
          latitude: loc.latitude,
          longitude: loc.longitude,
          street_number: loc.street_number,
          street_name: loc.street_name,
          city: loc.city,
          state: loc.state,
          state_code: loc.state_code,
          state_name: loc.state_name,
          zip: loc.zip,
          country_code: loc.country_code,
          provider: loc.provider,
          neighborhood: loc.neighborhood,
          district: loc.district,
          country: loc.country,
          accuracy: loc.accuracy
        }.to_json

        ap geocode_result

        update_columns(
          latitude: loc.latitude,
          longitude: loc.longitude,
          geocode_result: geocode_result,
          street_number: loc.street_number,
          street_name: loc.street_name,
          country_code: loc.country_code,
          state_code: loc.state_code
        )
      end
    rescue => error
      puts error.inspect
    end

  end


  def to_chef_info
    to_json(only: [
        :id, :first_name, :last_name,
        :street_number, :street_name, :address1,
        :address2, :city, :state, :country,
        :zip, :max_delivery_distance,
        :latitude, :longitude,
        methods: []
    ])
  end


  def create_strip_account(payment_info_params, current_user)
    @payment_account = PaymentAccount.new(payment_info_params)
    @payment_account.user_id = current_user.id
    @payment_account.chef_id = @chef.id
    @payment_account .save
  end


  def dob_info
    if dob.present?
      {
        dob_year: dob.year,
        dob_month: dob.month,
        dob_day: dob.day
      }
    end
  end


  def update_menu_locations(force = false)
    if force || latitude_changed? || longitude_changed?
      menus.update_all(latitude: latitude, longitude: longitude)
    end
  end


  def notice_display
    "#{pre_order_notice_hour} hour notice"
  end


  def order_info_display
    info = []
    info << "#{notice_display} required" if notice_display.present?
    if pre_order_min_order_amount.present? && pre_order_min_order_amount > 0.0
      info << "minimum $#{trim(pre_order_min_order_amount)} order"
    else
      info << "no minimum order amount"
    end

    if delivery_fee == 0.0
      info << "Free delivery"
    elsif delivery_fee.present? && delivery_fee > 0.0
      info << "$#{trim(delivery_fee)} delivery fee"
    end

    if free_delivery_min_order_amount.present? && free_delivery_min_order_amount > 0.0
      info << "minimum $#{trim(free_delivery_min_order_amount)} order for free delivery" 
    end

    if min_fee_for_onsite_cooking.present? && min_fee_for_onsite_cooking > 0.0
      info << "minimum $#{trim(min_fee_for_onsite_cooking)} order for onsite cooking" 
    end
    info.join(' | ')
  end


  def own_menu?(menu)
    menus.pluck(:id).include?(menu.id)
  end


  def distance_from(other_location)
    chef_location = Geokit::LatLng.new(latitude, longitude)
    distance = other_location.distance_to(chef_location)
    distance = '%.1f' % distance
    "#{distance} km"
  end

  private

  def update_assets_count
    assets_count = assets.count
  end


  def strip_whitespace
    self.first_name = self.first_name.strip unless self.first_name.nil?
    self.last_name = self.last_name.strip unless self.last_name.nil?
    self.street_name = self.street_name.strip unless self.street_name.nil?
    self.address1 = self.address1.strip unless self.address1.nil?
    self.address2 = self.address2.strip unless self.address2.nil?
    self.city = self.city.strip unless self.city.nil?
    self.state = self.state.strip unless self.state.nil?
    self.zip = self.zip.strip unless self.zip.nil?
    self.email = self.email.strip unless self.email.nil?
  end

end
