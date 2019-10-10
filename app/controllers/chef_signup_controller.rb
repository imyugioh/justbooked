class ChefSignupController < ApplicationController
  include Wicked::Wizard

  steps :chef_info, :first_menu, :payment_info, :welcome_message, :invite_complete
  before_filter :authenticate_user!, except: [:invites]
  before_filter :token
  before_action :set_info

  def show
    render_wizard
  end

  def update

    case step
      when :chef_info
      if @chef.id
        asset_info = create_assets
        cp = chef_params
        cp['profile_asset_id'] = asset_info[:profile_asset_id] if asset_info[:profile_asset_id]
        cp['header_asset_id'] = asset_info[:header_asset_id] if asset_info[:header_asset_id]
        @chef.update_attributes(cp)
      else
        asset_info = create_assets
        cp = chef_params
        @chef = Chef.new(cp)
        @chef.user_id = current_user.id
        @chef.profile_asset_id = asset_info[:profile_asset_id] if asset_info[:profile_asset_id]
        @chef.header_asset_id = asset_info[:header_asset_id] if asset_info[:header_asset_id]
        @chef.save
      end

      @chef.set_tag_list_on(:cuisine_type, cuisine_types.join(', ')) if cuisine_types
      @chef.save

      if @chef.errors.present?
        render wizard_path(:chef_info)
      else
        flash[:success] = "Chef information saved successfully."
        render_wizard @chef
      end
    when :first_menu

      menu_info = menu_params
      menu_info[:user_id] = current_user.id
      menu_info[:chef_id] = current_user.chef.id rescue nil

      ActiveRecord::Base.transaction do
        if menu_info[:id].present?
          @menu = Menu.find(menu_info[:id])
          @menu.update_attributes(menu_info)
        else
          @menu = Menu.create(menu_info)
        end
        
        @menu.set_tag_list_on(:cuisine_type, cuisine_types.join(', ')) if cuisine_types
        @menu.set_tag_list_on(:dietary_type, dietary_types.join(', ')) if dietary_types
        
        if @menu.save
          if assets = Asset.where(id: params[:assets].split(','))
            assets.update_all(assetable_id: @menu.id)
          end
        end
      end

      if @menu.errors.present? 
        render wizard_path(:first_menu)
      else
        flash[:success] = "Menu saved successfully."
        render_wizard @menu
      end

    when :payment_info

      # ap payment_info_params
      if @payment_info = @chef.payment_account
        @payment_info.ip_address = request.remote_ip
        @payment_info.dob_year = @chef.dob.year
        @payment_info.dob_month = @chef.dob.month
        @payment_info.dob_day = @chef.dob.day
        @payment_info.update_attributes(payment_info_params)
      else
        @payment_info = PaymentAccount.new(payment_info_params)
        @payment_info.ip_address = request.remote_ip
        @payment_info.dob_year = @chef.dob.year
        @payment_info.dob_month = @chef.dob.month
        @payment_info.dob_day = @chef.dob.day
        @payment_info.user_id = current_user.id
        @payment_info.chef_id = @chef.id
        @payment_info.save
      end

      if @payment_info.errors.present? 
        render wizard_path(:payment_info)
      else
        flash[:success] = "Payment information saved successfully."
        render_wizard @payment_info
      end
    when :welcome_message
      @chef = current_user.chef
      contacts = invitation_params[:contacts].split(',')
      InvitationWorker.perform_async(@chef.id, contacts, invitation_params[:message])
      render_wizard @chef
    when :invite_complete
      render_wizard
    end
  end

private

  def redirect_to_finish_wizard
    redirect_to root_url, notice: "Thank you for signing up"
  end

  def set_info
    case step
    when :chef_info
      @chef = current_user.chef || Chef.new
      if @chef.new_record?
        @email = current_user.email
      else
        @email = @chef.email
      end
    when :first_menu
      if current_user.chef.nil?
        jump_to(:chef_info) 
        return
      else
        @chef = current_user.chef
        @menu = @chef.menus.order(:created_at).first || Menu.new
      end
    when :payment_info
      if current_user.chef.nil?
        jump_to(:chef_info) 
        return
      else
        @chef = current_user.chef
        @payment_account = @chef.payment_account || PaymentAccount.new
      end
    when :welcome_message
      @chef = current_user.chef
    when :invite_complete
      @chef = current_user.chef
    end

  end


  # Never trust parameters from the scary internet, only allow the white list through.

  def chef_params
    allowed_params = params.require(:chef).permit(
                                  :first_name, :last_name, :address1, :address2, :zip, :email,
                                  :city, :state, :dob, :phone, :about, :max_delivery_distance,
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


  
  def menu_params
    m_params = params.require(:menu).permit(
                                  :id, :name, :description, :price, :auto_accept,
                                  :cusine_type, :dietary_type)
     
    m_params[:price] = m_params[:price].tr('^0-9.', '') if m_params[:price].present?
    m_params
  end


  def cuisine_types
    params[:tags][:cuisine_types] rescue []
  end


  def dietary_types
    params[:tags][:dietary_types] rescue []
  end


  def assets_params
    params.require(:assets).permit(:profile_image, :header_image, :token)
  end


  def payment_info_params
    params.require(:payment_account).permit(
      :first_name, :last_name, :account_number, :currency, 
      :routing_number, :business_type,
      :business_name, :business_tax_id,
      :stripe_terms_of_services      
    )
  end

  def invitation_params
    params.require(:invitation).permit(:contacts, :message)
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

  def create_assets
    profile = @chef.profile_asset
    header = @chef.header_asset

    if  assets_params['profile_image']
      profile = Asset.create(image: assets_params['profile_image'], token: assets_params['token'], assetable_type: 'Chef', assetable_id: @chef.id, asset_detail: 'profile')
    end

    if assets_params['header_image']
      header = Asset.create(image: assets_params['header_image'], token: assets_params['token'], assetable_type: 'Chef', assetable_id: @chef.id, asset_detail: 'header')
    end

    {profile_asset_id: (profile.id rescue nil), header_asset_id: (header.id rescue nil)}
  end


end




