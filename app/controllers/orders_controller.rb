class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  before_filter :authenticate_user!, except: [:token_order]
  def index
    if current_user && current_user.is_chef?
      @all      = Purchase.where(chef_id: current_user.chef.id)
      @all = (@all.sort_by &:updated_at).reverse
      @new      = Purchase.where(chef_id: current_user.chef.id, request_status: 'New')
      @accepted = Purchase.where(chef_id: current_user.chef.id, request_status: 'Accepted')
      @declined = Purchase.where(chef_id: current_user.chef.id, request_status: 'Declined')
      render 'index'
    else
      @all      = Purchase.where(user_id: current_user.id)
      render 'customer_order'
    end
  end

  def order_details
  	@menus ||= []
  	if @purchase = Purchase.find_by_id(params[:id])
      @purchase.menus.each do |item|
        menu = Menu.find_by_id(item.model_id)
        @menus.push("<div class='purchase-menu'><span class='red-amount'>#{item.amount}</span> #{menu.name} ($#{number_with_precision(item.sub_total, precision: 2)})</div>")

        item.menu_items.each_with_index do |purchase_menu_item, index|
          if index == 0
            @menus.push("<div class='purchase-item-separator'>Order Selections:</div>")
          end
          if menu_item = MenuItem.find_by_id(purchase_menu_item.model_id)
            @menus.push("<div class='purchase-submenu'><span class='red-amount'>#{purchase_menu_item.amount}</span> #{menu_item.name} ($#{number_with_precision(purchase_menu_item.sub_total, precision: 2)})</div>")
          end
        end

        item.addons.each_with_index do |purchase_addon, index|
          if index == 0
            @menus.push("<div class='purchase-item-separator'>Add ons:</div>")
          end
          if addon = Addon.find_by_id(purchase_addon.model_id)
            @menus.push("<div class='purchase-submenu'>#{addon.name} ($#{number_with_precision(purchase_addon.sub_total, precision: 2)})</div>")
          end
        end

        if item.detail.present?
          @menus.push("<div class='purchase-item-separator'>Special Instructions:</div>")
          @menus.push("<div class='purchase-submenu'>#{simple_format(item.detail)}</div>")
        end
        @menus.push("<div class='purchase-menu-separator'></div>")
      end
  	end
  end

  def token_order

    if user = User.find_by(:token => params[:token])
      sign_in(user)
      redirect_to order_details_path(:id => params[:id])
    end
  end
end
