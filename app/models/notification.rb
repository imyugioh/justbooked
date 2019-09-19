class Notification < ActiveRecord::Base
  belongs_to :noteable, polymorphic: true

  after_create :publish_event

  def publish_event
    message = "You have received a new request for #{self.noteable.venue.name} venue."
    json = {id: id, body: {
        new_notice: true,
        message: message,
        link: "/notifications/#{id}"
      }
    }
    json[:event_type] = 'Notification'
    ::Live.publish_async("notifications_for_#{noteable.venue.user.token}", json.as_json)
  end
end
