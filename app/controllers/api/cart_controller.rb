module Api
  class CartController < ApiController
    before_action :check_current_user!, only: [:create]
    respond_to :json

    def index
    end

    def create
    end

    def show
    end

    private


  end
end
