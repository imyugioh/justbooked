class ChefsController < ApplicationController

  def index
  end

  def get_index
    @chef = Chef.includes(:menus).friendly.find(params[:id])
    @menus = @chef.menus
  	@menu_item = @menus.find_by_id(params[:menu_id])
    @reviews = Review.where(:menu_id => params[:menu_id])
    @reviews = (@reviews.sort_by &:updated_at).reverse
    @avg_rate = 0

    if @reviews.size != 0
      @reviews.each do |item|
        @avg_rate = @avg_rate + item.rating
      end
      @avg_rate = @avg_rate.to_f / (@reviews.size)

      respond_to do |format|
        format.js
      end
    end
  end

  def show
  	@class_name = "detail_view"
    @chef = Chef.includes(menus: [:assets, :menu_items, :addons, :menu_category]).friendly.find(params[:id])
    @menus = @chef.menus.includes(:reviews).order(:price)
    @reviews ||= []
    @menus.each do |m|
      ref = m.reviews
      avg_rate = 0.0
      ref.each do |re|
        avg_rate = avg_rate.to_f + re.rating
      end
      if ref.size == 0
        @reviews.push([0, 0])
      else
        @reviews.push([ref.size, avg_rate.to_f / ref.size, m.id])
      end
    end

    if @menus.count > 0
      render 'show'
    else
      render 'no_menu'
    end
  end
  
end
