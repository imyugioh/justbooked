module Api
  class SearchController < ApiController
    include ApplicationHelper
    include Geokit::Geocoders
    before_action :check_current_user!, only: [:create, :update, :favorites_toggle, :dashboard]
    respond_to :json

    PER_PAGE = 15

    # http://localhost:3000/listings?location=Toronto,%20ON,%20Canada&lat=43.653226&lng=-79.38318429999998&mode=restaurant&q=American
    def index
      if search_params[:lat] && search_params[:lng]
        @search_location = Geokit::LatLng.new(search_params[:lat], search_params[:lng])
      end

      if @search_location.nil?
        @search_location = search_params[:location] || "Toronto, Ontario"
        if geo_info = get_user_location
          @search_location = Geokit::LatLng.new(geo_info['lat'], geo_info['lng'])
        else
          # Default Toronto
          @search_location = Geokit::LatLng.new(43.6532, -79.3822)
        end
      end

      @all_chefs = Chef.where(listed: true).where("menus_count > 0").within_location(@search_location, search_params[:distance])

      if params[:qr].present?
        # search by name
        t = "%#{params[:qr]}%"
        @chefs = @all_chefs.where(["LOWER(first_name) like LOWER(?) OR LOWER(last_name) like LOWER(?)", t, t])
        # search by tag
        m = params[:qr]
        tags = m.split(' ')
        tags.unshift(m)
        @chefs += @all_chefs.tag(tags)
      else
        @chefs = @all_chefs
      end
      
      if @all_chefs.present?
        @all_menus = Menu.order('id ASC').within_location(@search_location, search_params[:distance]).where(listed: true).where(chef_id: @all_chefs.pluck(:id)).includes(:assets, :chef)
        if params[:qm].present?
          m = params[:qm]
          tags = m.split(' ')
          tags.unshift(m)
          @all_menus = @all_menus.tag(tags)
        end

        if @all_menus.present? == false && params[:qm].present?
          @all_menus = Menu.order('id ASC')
                          .where(listed: true)
                          .where("lower(name) like ?", "%#{params[:qm].downcase}%")
                          .within_location(@search_location, search_params[:distance])
                          .where(chef_id: @all_chefs.pluck(:id))
                          .includes(:assets, :chef, :reviews)
        end
      end

      @all_menus = [] unless @all_menus

      if @all_menus.length > 0
        @menus = @all_menus.paginate(
          page: search_params[:page] || 1, per_page: PER_PAGE
        ).shuffle
      else
        @menus = []
      end

      render(template: 'api/search/index', formats: :json, locals: {search_location: search_params[:location], search_keywords: search_params[:q]})
    end


    # returns search filters
    def filters
    end


    private

    def search_params
      params.permit(:q, :location, :lat, :lng, :distance, :page, :per_page, :format, :search)
    end
  end
end
