class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @similar_venues = Venue.where(
      listed: true
    ).last(10).sample(4)
  end

  def show
    note = current_user.notifications.find(params[:id])
    note.update_attributes(read: true)
    redirect_to booking_path(note.noteable.token) if note.message_key == 'new_booking'
  end
end
