class BookingSerializer < ActiveModel::Serializer
  attributes :id, :status, :sender, :recipient, :package_info,
    :delivery_info, :date_start, :time_start, :end_time,
    :guests_count, :details, :event_type, :url, :payment_url

  def url
    object.url(serialization_options[:user_signed_in])
  end

  def payment_url
    "/chef/#{object.venue.slug}/packages/#{object.package.slug}/bookings/#{object.token}/payment"
  end

  def guests_count
    object.estimated_guests_count
  end

  def sender
    senderid = object.sender.present? ? object.sender_id : nil
    {
      id: senderid,
      first_name: object.first_name,
      last_name: object.last_name,
      email: object.email,
      phone: object.phone
    }
  end

  def status
    Booking::STATUS[object.status]
  end
end

# venue_id: 25, recipient_id: 1,
# hidden_for_sender: false, hidden_for_recipient: false,
# status: 2, read_by_sender: true, read_by_recipient: true,
# email_sent: true, email_sent_at: nil, # package_id: 5,
