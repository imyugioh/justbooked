class BookingListSerializer < ActiveModel::Serializer
  attributes :id,  :status, :sender,
    :recipient, :venue, :type, :estimated_guests_count,
    :created_at, :was_read, :charge_status, :charge_attempts, :token, :delivery_quantity

  def type
    serialization_options[:user_id] == object.sender_id ? 'sent' : 'received'
  end

  def was_read
    return true if (serialization_options[:user_id] == object.sender_id) && object.read_by_sender
    return true if serialization_options[:user_id] == object.recipient_id && object.read_by_recipient
  end

  # def hidden_for_current_user
  #   return true if (serialization_options[:user_id] == object.sender_id) && object.hidden_for_sender
  #   return true if serialization_options[:user_id] == object.recipient_id && object.hidden_for_recipient
  #   false
  # end

  def sender
    {
      id: object.id,
      name: (serialization_options[:user_id] == object.sender_id) ? 'You' : (object.sender ? object.sender.full_name : object.full_name)
    }
  end

  def recipient
    {
      id: object.id,
      name: object.recipient.full_name
    }
  end

  def venue
    {
      id: object.venue.id,
      name: object.venue.name,
      link: Rails.application.routes.url_helpers.venue_url(object.venue)
    }
  end

  def charge_attempts
    object.charge.charge_attempts if object.charge
  end

  def charge_status
    charge = object.charge
    return 'In progress' unless charge.present?
    return 'Failed' if charge.failed?
    charge['stripe_response']['status'] if charge.captured
  end

  def status
    Booking::STATUS[object.status]
  end
end
