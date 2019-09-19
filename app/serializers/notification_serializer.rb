class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at

  def body
    if object.message_key == 'new_booking'
      booking = object.noteable
      if booking && booking.venue
        message = "New order from #{booking.full_name}."
      else
        message = 'Record is not available, it was removed by admin or owner'
      end

      return {
        new_notice: !object.read,
        message: message,
        link: "/notifications/#{object.id}"
      }
    end
  end
end
