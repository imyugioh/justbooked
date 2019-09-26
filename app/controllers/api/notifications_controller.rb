module Api
  class NotificationsController < ApiController
    before_action :check_current_user!

    respond_to :json

    def index
      notifications = current_user.notifications.order('id desc')
      new_notifications = notifications.where(read: false).count
      render json: notifications, meta: { counter: new_notifications }
    end

    def mark_all_as_read
      if params[:notification][:ids].present?
        notifications = current_user.new_notifications.where(id: params[:notification][:ids]).update_all(read: true)
      end
      render json: { status: 200 }
    end

    def mark_as_read
      notification = current_user.new_notifications.where(id: params[:id]).first

      if notification.present? && notification.update_attributes(read: true)
        render json: notification, status: 200
      else
        render json: { status: 400 }
      end
    end

    def destroy
      notification = current_user.notifications.find(params[:id])
      if notification.destroy
        render json: notification, status: 200
      else
        render json: { status: 400 }
      end
    end

    private

    def request_params
      params.require(:request).permit(
        :first_name, :last_name, :email, :phone, :date_start, :time_start,
        :estimated_guests_count, :venue_id, :venue_id, :details, :event_type_id)
    end
  end
end
