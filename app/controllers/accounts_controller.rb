class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_info
  before_filter :token, only: [:edit, :certification] 
  layout 'account'

  def edit
    @class = 'info'
    if current_user.is_chef?
      @chef = current_user.chef
    else
      @chef = current_user
    end
    @payment_account = @chef.payment_account || PaymentAccount.new
  end

  def payment_settings
    @class = 'info'
    if current_user.is_chef?
      @chef = current_user.chef
    else
      @chef = current_user
    end
    @payment_account = @chef.payment_account || PaymentAccount.new

  end

  def update
    result = false
    if @chef && @user.is_chef?
      asset_info = create_chef_assets
      cp = chef_params
      cp['profile_asset_id'] = asset_info[:profile_asset_id] if asset_info[:profile_asset_id]
      cp['header_asset_id'] = asset_info[:header_asset_id] if asset_info[:header_asset_id]
      result = @chef.update_attributes(cp)

      if result # need to update cusine_type
        @chef.set_tag_list_on(:cuisine_type, cuisine_types.join(', ')) if cuisine_types
        result = @chef.save
        puts "---------> saving update"
        puts result
      end
    else
      result = @user.update_attributes(user_params)
    end

    if result
      redirect_to edit_account_path, flash: {success: "Information was successfully updated."}
    else
      render :edit, flash: {error: "Please enter required information"}
    end

  end

  def certification
  end

  def save_certification_documents
    create_chef_documents
    redirect_to certification_account_path, flash: {success: "Information was successfully updated."}
  end
  
  def save_password
    if user_params[:password] != user_params[:password_confirmation]
      @text = "Password doesn't match!"
    else
      @user.update_attributes!(:password => user_params[:password], :password_confirmation => user_params[:password_confirmation])
      @text = "Password successfully changed!"
    end
    redirect_to controller: 'accounts', action: 'password'
  end

  def payments
    notice = "You can't update payment settings without account"
    return redirect_to account_path, notice: notice unless current_account

    @class = 'payments'
    @user = current_user
    account = Stripe::Account.retrieve(current_account.stripe_account)
    gon.account = account

    
    puts @payment_account
    puts @chef.dob.day
  end

  def favorites
    @class = 'favorites'
    @venues = current_user.find_liked_items
  end

  def password
    @class = 'password'
    puts '..........'
    puts current_user.password
  end

  def my_venues
    @class = 'my_venues'
    @venues = current_user.venues
  end

  def newsletter
    @class = 'newsletter'
    @user = current_user
  end

  def order_details
  end


  private

  def chef_params
    allowed_params = params.require(:chef).permit(
                                  :first_name, :last_name, :address1, :address2, :zip, :email, :email_sec,
                                  :city, :state, :dob, :phone, :phone_sec, :about, :max_delivery_distance,
                                  :country, :pre_order_notice_hour,
                                  :pre_order_min_order_amount, :delivery_fee,
                                  :free_delivery_min_order_amount, :min_fee_for_onsite_cooking,
                                  :onsite_cooking_available, :pickup_available, :shareables, :individually_packaged, :price_category,
                                  event_types: [],
                                  menu_categories_attributes: [:id, :name, :_destroy]
                                )
    allowed_params[:delivery_fee] = allowed_params[:delivery_fee].scan(/\d+/).first
    allowed_params[:pre_order_min_order_amount] = allowed_params[:pre_order_min_order_amount].scan(/\d+/).first
    allowed_params[:free_delivery_min_order_amount] = allowed_params[:free_delivery_min_order_amount].scan(/\d+/).first
    allowed_params[:min_fee_for_onsite_cooking] = allowed_params[:min_fee_for_onsite_cooking].scan(/\d+/).first

    if allowed_params[:onsite_cooking_available] == 'on'
      allowed_params[:onsite_cooking_available] = true
    else
      allowed_params[:onsite_cooking_available] = false
    end

    if allowed_params[:pickup_available] == 'on'
      allowed_params[:pickup_available] = true
    else
      allowed_params[:pickup_available] = false
    end

    allowed_params[:shareables] = allowed_params[:shareables] == 'true'
    allowed_params[:individually_packaged] = allowed_params[:individually_packaged] == 'true'

    allowed_params                                                        
  end

  def cuisine_types
    params[:tags][:cuisine_types] rescue []
  end

  def user_params
    params.require(:user).permit(
                                  :first_name, :last_name, :address1, :address2, :zip, :email, :email_sec,
                                  :city, :state, :phone, :phone_sec, :country, :password, :password_confirmation
                                )
  end

  def assets_params
    params.require(:assets).permit(:profile_image, :header_image, :token)
  end

  def documents_params
    params.require(:documents).permit(:food_handler_certification, :personal_identification, :token)
  end

  def create_chef_assets
    profile = @chef.profile_asset
    header = @chef.header_asset
    if  assets_params['profile_image']
      profile = @chef.replace_profile_asset(assets_params)
    end
    
    if assets_params['header_image']
      header = @chef.replace_header_asset(assets_params)
    end
    {profile_asset_id: (profile.id rescue nil), header_asset_id: (header.id rescue nil)}
  end
  

  def create_chef_documents
    personal_identification = @chef.personal_identification
    food_handler_license = @chef.food_handler_certification

    if  documents_params['food_handler_certification']
      food_handler_certification = @chef.replace_food_handler_certification(documents_params)
    end
    
    if documents_params['personal_identification']
      personal_identification = @chef.replace_personal_identification(documents_params)
    end
    {food_handler_certification: (food_handler_certification.id rescue nil), personal_identification: (personal_identification.id rescue nil)}
  end
  

  def set_info
    @chef = current_user.chef || current_user
    @user = current_user
    @payment_account = @chef.payment_account || PaymentAccount.new
  end


  def payment_info_params
    params.require(:payment_account).permit(
      :first_name, :last_name, :account_number, :currency, 
      :routing_number, :business_type,
      :business_name, :business_tax_id,
      :stripe_terms_of_services      
    )
  end

  def allocate_schedule(csp, trans_scp)
    [:mon, :tue, :wed, :thu, :fri, :sat, :sun].each do |dow|
      [:start, :end].each do |mode|
        k = "#{dow}_#{mode}"
        # puts csp["off_#{dow}"]
        if csp["off_#{dow}"] == 'true'
          trans_scp[k.to_sym] = nil
        end
      end
    end
    trans_scp
  end
  
end
