module Api
  class MenusController < ApplicationController
    def show
      @menu = Menu.find_by_id(params[:id])
      render json: @menu, include: [:menu_items, :addons], status: :ok
    end
  end
end
