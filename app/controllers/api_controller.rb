class ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    render json: { error: 'not found' }, status: 404
  end

  protected

  def check_current_user!
    return render json: {
      error: 'not authorized' }, status: 401 unless current_user
  end
end
