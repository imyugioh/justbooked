module Api
  class AssetsController < ApiController
    layout false
    before_action :check_current_user!
    before_filter :token
    respond_to :json

    def index
      @asset = Asset.new
    end

    def create
      asset = Asset.new(asset_params)
      if asset.save!
        render json: asset
      else
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end


    def delete_venue_asset
      venue = Venue.friendly.find(params[:venue_id])
      asset = venue.assets.where(id: params[:id]).first
      if asset.present?
        asset.destroy
        render json: { message: 'Sucess' }, status: 200
      else
        render json: { message: 'Not Found' }, status: 404
      end
    end

    def destroy
      asset = Asset.where(id: params[:id], token: params[:token]).first
      if asset.present?
        asset.destroy
        render json: { message: 'Sucess' }, status: 200
      else
        render json: { message: 'Not Found' }, status: 404
      end
    end


    private

    def asset_params
      asset_params = params.require(:asset).permit(:token, :image, :assetable_type, :assetable_id)
    end

    def token
      @token = SecureRandom.uuid
    end

  end
end
