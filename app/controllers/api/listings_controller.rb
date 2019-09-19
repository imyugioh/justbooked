module Api
  class ListingsController < ApiController
    before_action :check_current_user!, only: [:create]
    respond_to :json

    def index

      result = Menu.search(listings_params[:lat], listings_params[:lng], params[:location], params[:distance], params[:page] || 1) 

      @search_location = result.search_location
      @chefs = result.chefs
      @listing_count = result.listing_count
      @menus = result.menus


      @geo_json = ActionController::Base.new().render_to_string( template: 'listings/index.json.jbuilder', locals: {menus: @menus}, format: :json)

    end



    private


    def review_params
      params.require(:review).permit(:comment)
    end
    
  end
end
