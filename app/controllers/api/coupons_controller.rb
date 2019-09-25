module Api
  class CouponsController < ApiController
    before_action :check_current_user!
    respond_to :json

    def show
      coupon = Coupon.available.where(
        'name = ? AND start_date <= ? AND end_date >= ?',
        params[:id], Date.today, Date.today).first

      unless coupon.present? && coupon.available?(current_user.id)
        fail ActiveRecord::RecordNotFound
      end
      render json: coupon, root: :coupon
    end
  end
end
