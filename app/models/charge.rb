class Charge < ActiveRecord::Base
  define_model_callbacks :charge, only: [:after]

  after_create :charge_if_needed
  after_charge :send_charge_notification, :track_event

  monetize :amount # , allow_nil: false, disable_validation: true
  monetize :service_fee # , allow_nil: false, disable_validation: true
  belongs_to :booking

  def capture
    return if captured
    run_callbacks :charge do
      begin
        charge = Stripe::Charge.create(
          amount: amount.to_i,
          currency: 'cad',
          customer: (ENV['APP_SHORT_NAME'] + '_' + booking.sender.id.to_s if booking.sender.present?),
          source: booking.stripe_card_id,
          description: "Charge for #{booking.package.title}",
          application_fee: service_fee.to_i,
          destination: booking.recipient.account.stripe_account,
          # receipt_email: (booking.sender.email if booking.sender.present?),
          statement_descriptor: "Order #{booking.id}"
        )
      rescue Stripe::CardError => e
        self.stripe_response = { errors: [e.message] }
        self.charge_attempts = charge_attempts + 1
        save!
      else
        if charge.present?
          self.stripe_response = charge.to_json
          self.captured = true
          self.charge_attempts = charge_attempts + 1
          Booking.delay_for(
            5.seconds, queue: 'default', retry: true
          ).refund_coupon(booking.id) if booking.coupon
          save!
        end
      end
    end
  end

  def last4
    "xxxx-xxxx-xxxx-#{stripe_response['source']['last4']}"
  end

  def failed?
    !captured? && stripe_response && stripe_response['errors'].present?
  end

  private

  def charge_if_needed
    capture if booking.capture_now?
  end

  def send_charge_notification
    return unless captured
    [booking.sender, booking.recipient].each do |user|
      UserMailer.delay_for(
        5.seconds, queue: 'bookings_mailer', retry: true
      ).charge_notification(booking.id, user)
    end
  end

  def track_event
    return unless captured
    Tracker.track(
      (booking.sender ? booking.sender_id.to_s : 'guest'),
      'Payment charged', id: id)
  end
end
