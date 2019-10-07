class CartController < ApplicationController
  before_action :check_cart_access, only: [:show, :edit, :update, :destroy]

  def show
    if current_user
      @user_info = {
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def check_cart_access
    @cart_chef = Chef.find(params[:chef_id]) rescue nil
    @cart = Cart.find_by(id: params[:id]) rescue nil
    if @cart_chef.nil? || @cart.nil?
      puts ">>>>>>>>> not user cart or cart does not exist."
      redirect_to root_path, flash: {error: "Can not access the cart" }
    end
  end

end
