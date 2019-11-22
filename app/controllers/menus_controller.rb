class MenusController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:show, :edit, :update, :destroy]
  before_filter :token

  # GET /menus
  # GET /menus.json
  def index
    @menus = Menu.all
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new
    @chef = current_user.chef
  end

  # GET /menus/1/edit
  def edit
    @chef = @menu.chef || current_user.chef
  end

  # POST /menus
  # POST /menus.json
  def create
    result = Menu.create_or_update_records(current_user, menu_params, assets_params, tag_params)
    @menu = result[:menu]

    respond_to do |format|
      if result[:saved]
        format.html { redirect_to current_user.chef.my_listings_path, notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update

    puts 'menu-params---------'
    puts menu_params
    # puts tag_params

    respond_to do |format|
      result = Menu.create_or_update_records(current_user, menu_params, assets_params, tag_params)
      @menu = result[:menu]

      if result[:saved]
        format.html { redirect_to current_user.chef.my_listings_path, notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      m_params = params.require(:menu).permit(:id, :name, :description, :price, :per, :min_order_amount, :auto_accept,
                                   :cusine_type, :dietary_type, :menu_category_id, :menu_type,
                                   menu_items_attributes: [:id, :name, :price, :_destroy], addons_attributes: [:id, :name, :price, :_destroy])

      m_params[:price] = m_params[:price].tr('^0-9.', '') if m_params[:price].present?
      m_params
    end

  def group_params
    params.require(:group).permit(:group_name, :group_title, group_members: [:id, :darknet_accountname, :access_level])
  end

  def tag_params
    params.require(:tags)
  end

  def assets_params
    params.require(:assets)
  end

  def menu_items_params
    if params[:menu_items]
      params[:menu_items]
    end
  end

  def addon_params
    if params[:addons]
      params[:addons]
    end
  end

  def check_ownership
    chef = @menu.chef
    if chef.id != current_user.chef.id
      redirect_to root_path unless @chef.own_menu?(@menu)
    end
  end

end
