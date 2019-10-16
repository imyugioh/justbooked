class ListingsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, except: [:show, :index, :favorites, :redeem]
  PER_PAGE = 15

  def index
    GeoCoder.perform_later(request.session_options[:id], request.remote_ip)
    Tracker.track(current_user.id, 'Visited search page') if current_user.present?
  end


  def new
    @token = SecureRandom.uuid
    Tracker.track(current_user.id, 'Visited new venue page')
  end

  def create
  end

  def edit
    @token = SecureRandom.uuid
  end

  def dashboard
    Tracker.track(current_user.id, 'Visited dashboard page', {
      venue_id: @venue.id, slug: @venue.slug
    })
  end

  def redeem
    @venue = Venue.where(token: params[:id], redeemed: false).first
    redirect_to root_path unless @venue.present?
  end

  def destroy
  end

  private


  def listings_params
    params.permit(:location, :q, :lat, :lng, :page, :price, :cuisine_type, :search, :format)

    params[:lat] = 43.653226 unless (params[:lat].present?)
    params[:lat] = -79.38318429999998 unless (params[:lng].present?)
    params[:location] = "Toronto, ON, Canada" unless (params[:locaton].present?)

    params
  end

  def load_owned_venue
    @menu = current_user.menus.friendly.find(params[:id])
  end

  def load_menu
    @menu = Menu.friendly.find(params[:id])
  end

  def verify_ownership
    return if current_user.owner_of?(@menu)
    redirect_to root_path
    flash[:danger] = 'Wrong move mate! Only menu owner has access to this page.'
  end

  def verify_if_can_add_menu
    return if current_user.can_add_menus?
    redirect_to root_path
    limit = ActionController::Base.helpers.pluralize(current_user.menus_limit, 'menu')
    flash[:error] = "You can't add more then #{limit} at the moment."
  end

end
