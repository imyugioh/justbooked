class Menu < ActiveRecord::Base
  include PgSearch
  extend FriendlyId
  has_secure_token
  is_impressionable
  # acts_as_commentable
  acts_as_list

  monetize :price, allow_nil: true, disable_validation: true
  has_many :assets, as: :assetable, dependent: :destroy
  belongs_to :user
  belongs_to :chef, :counter_cache => true
  has_many :reviews
  has_many :menu_items
  has_many :addons

  belongs_to :menu_category

  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude


  friendly_id :name, use: :slugged

  acts_as_votable
  # acts_as_taggable
  acts_as_taggable_on :cuisine_type, :dietary_type, :order_selection, :add_ons

  before_save :update_assets_count
  before_save :update_geo_location

  validates :name, :description, :price, :min_order_amount, presence: true

  # TODO - fix validations in seed
  validates_length_of :description, in: 10..1500

  validate :cuisine_type_presence
  validates :menu_type, inclusion: { in: %w(single package addon), message: "%{value} is not a valid meny_type" }

  PER_PAGE = 200

  # validate :image_presence

  # Default earger loading for tags
  default_scope { includes(:menu_items, :addons) }

  scope :within_location, -> (search_location, distance) {
    distance = Rails.configuration.x.default_search_distance unless distance
    within(distance, :units => :kms, :origin => search_location).by_distance(origin: search_location)
  }

  accepts_nested_attributes_for :menu_items, allow_destroy: true
  accepts_nested_attributes_for :addons, allow_destroy: true


  def self.search(lat, lng, address, distance, page) 
      if lat.present? && lng.present?
        search_location = Geokit::LatLng.new(lat,lng)
      else
        if location = MultiGeocoder.geocode(address)
          search_location = Geokit::LatLng.new(location.lat, location.lng)
          # puts ">>>>>>>> geo searched: #{search_location.lat}, #{search_location.lng}"
        end
      end

      # Default Toronto
      if search_location.nil?
        search_location = Geokit::LatLng.new(43.6532, -79.3822)
      end


      # First find chef in the location
      chefs = Chef.within_location(search_location, distance)

      all_menus = Menu.where(listed: true).where(chef_id: chefs.pluck(:id)).includes(:assets)


      listing_count = all_menus.count


      menus = all_menus.paginate(
        page: (page || 1), per_page: PER_PAGE
      )

      {
        menus: menus,
        search_location: search_location,
        listing_count: listing_count
      }
  end


  def self.popular_cuisine_types
    self.tag_counts_on('cuisine_type', :limit => 10, :order => "taggings_count desc")
  end

  def self.popular_dietary_types
    self.tag_counts_on('dietary_type', :limit => 10, :order => "taggings_count desc")
  end


  def self.create_or_update_records(user, menu_params, assets_params, tags_params)
    menu = nil
    menu_info = menu_params
    menu_info[:user_id] = user.id
    menu_info[:chef_id] = user.chef.id rescue nil
    result = false

    ActiveRecord::Base.transaction do
      if menu_info[:id].present?
        menu = Menu.find(menu_info[:id])
        menu.update_attributes(menu_info)
      else
        menu = Menu.create(menu_info)
      end

      if tags_params[:cuisine_types].present?
        cuisine_types = tags_params[:cuisine_types].join(', ')
        menu.set_tag_list_on(:cuisine_type, cuisine_types)
      end

      if tags_params[:dietary_types].present?
        dietary_types = tags_params[:dietary_types].join(', ')
        menu.set_tag_list_on(:dietary_type, dietary_types)
      end

      result = menu.save

      # Assing assets to the menu
      if assets_params
        if assets = Asset.where(id: assets_params.split(','))
          assets.update_all(assetable_id: menu.id)
        end
      end

    end    
    {saved: result, menu: menu}
  end

  def self.tag(tag)
    if tag
      tagged_with(tag, any: true)
    else
      all
    end
  end

  def self.geo_search(params, search_location)
    default_search_distance = 50

    menus = Menu.where(listed: true).includes(:assets)

    # venue type: pizza, italian
    if params[:menu_type].present? && params[:menu_type] != 'any'
      menus = menus.tagged_with(params[:menu_type], on: :menu_types, any: true)
    end
    menus = menus.within(default_search_distance, origin: search_location).by_distance(origin: search_location)

    # TODO: Remove this
    menus = Menu.where(listed: true).includes(:assets) unless menus.present?

    menus
  end


  def self.recently_added(count = 4)
    self.includes(:chef, :assets).where(listed: true, menu_type: 'single').where("price > 10.0").order("created_at desc").limit(count)
  end


  def self.menu_types_options
    [[:Single, :single], [:Package, :package]]
  end

  def single?
    menu_type == 'single'
  end

  def package?
    menu_type == 'package'
  end

  # def price
  #   if self[:price].present?
  #     single? ? self[:price] : self[:price] * min_order_amount
  #   else
  #     nil
  #   end
  # end

  def chef_page
    chef.my_listings_path
  end

  def likes
    reviews = Review.where(:menu_id => self.id)
    reviews.size
  end

  def average_rating
    reviews = Review.where(:menu_id => self.id)
    avg_rating = 0.0
    if reviews.size == 0
      return 0
    else
      reviews.each do |t|
        avg_rating = avg_rating + t.rating
      end
    end
    avg_rating = avg_rating.to_f / (reviews.size)
    avg_rating = (avg_rating * 20.0).to_i
    return avg_rating
  end

  def latitude
    chef.latitude || nil
  end

  def longitude
    chef.longitude || nil
  end

  def images
    assets.collect { |a| a.image.url(:menu_medium) }
  end

  def cuisine_type_tag_names
    cuisine_type.select(:name).pluck(:name)
  end

  def dietary_type_tag_names
    dietary_type.select(:name).pluck(:name)
  end


  def tag_names
    [cuisine_type_tag_names, dietary_type_tag_names].flatten.sort
  end

  def tag_ids
    [cuisine_type.select(:id).pluck(:id), dietary_type.select(:id).pluck(:id)].flatten.sort.uniq
  end

  def assign_assets(token)
    return if assets.count >= 6
    Asset.where(
      assetable_type: 'Menu', token: token
    ).update_all(assetable_id: id, token: nil)
  end

  def main_image_url
    return '' unless assets.any?
    assets.first.image.url(:menu_medium)
  end

  def original_image_url
    return '' unless assets.any?
    assets.first.image.url(:original)
  end

  def main_thumb_url
    return '' unless assets.any?
    assets.first.image.url(:menu_thumb)
  end

  def cuisine_type_presence
    errors.add(:base, 'Menu should have at least one cuisine type') unless self.tag_list_on(:cuisine_type).any?
  end


  def comments_count
    reviews.count
  end

  def distance_from(search_location)
    chef_location = Geokit::LatLng.new(chef.latitude, chef.longitude)
    distance = search_location.distance_to(chef_location)
    distance = '%.1f' % distance
    "#{distance} km"
  end

  def to_menu_info
    to_json(only: [:id, :name, :price])
  end

  def display_price
    "$#{price}"
  end

  def cuisine_type_presence
    errors.add(:base, 'Menu should have at least one cuisine type') unless self.tag_list_on(:cuisine_types).any?
  end

  def image_presence  
    errors.add(:base, 'Required at least one menu images') unless self.assets.any?
  end

  private

  def update_assets_count
    assets_count = assets.count
  end

  def update_geo_location
    if chef.present?
      if chef.latitude.present? && chef.longitude.present?
        self.latitude = chef.latitude
        self.longitude = chef.longitude
      end
    end
  end

end
