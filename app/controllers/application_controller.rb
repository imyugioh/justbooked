class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :null_session

  # protect_from_forgery except: :sign_in
  # protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_cart
  before_filter :initate_recent_session_storage

  helper_method :current_account, :stripe_account

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  # def app_settings
  #   @app_settings ||= AppSetting.first
  # end

  def current_account
    return unless current_user
    current_user.account
  end

  def stripe_account
    return unless current_account
    return if current_account.stripe_account.nil?
    Stripe::Account.retrieve(current_account.stripe_account)
  end

  def token
    @token = SecureRandom.uuid
  end

  protected

  def after_sign_in_path_for(resource)
    params[:redirect_url] || request.env['omniauth.origin'] || stored_location_for(resource) || root_url
  end

  def initate_recent_session_storage
    session[:recent] ||= []
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name << :email << :password
    update_attrs = [:password, :password_confirmation]
  end
  
  def set_cart

    begin
      @newsletter = Newsletter.new
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create(session_id: session[:session_id])
      puts ">>>>>>>>>>>> new cart #{@cart.id} has been created"
    end
    session[:cart_id] = @cart.id
  end
end
