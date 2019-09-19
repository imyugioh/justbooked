class Purchase < ActiveRecord::Base
  before_create :generate_token
  has_many :purchase_items

  # define_model_callbacks :charge, only: [:after]

  # after_create :charge_if_needed
  # after_charge :send_charge_notification, :track_event

  # monetize :amount # , allow_nil: false, disable_validation: true
  # monetize :service_fee # , allow_nil: false, disable_validation: true
  belongs_to :chef
  belongs_to :user
  belongs_to :cart

  validates :order_type, inclusion: { in: %w(delivery pickup onsite-cooking), message: "%{value} is not a valid type" }  
  SERVICE_FEE_PORTION = 0.2

  def get_address_from_type
    case self.order_type
    when 'delivery'
      self.delivery_address
    when 'pickup'
      self.chef.full_address
    else
      self.delivery_address
    end
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Purchase.exists?(token: random_token)      
    end
  end

  def purchase_user
    if user_id
      User.find(user_id)
    else
      OpenStruct.new(email: email, first_name: first_name, last_name: last_name)
    end
  end

  def capture

    return if captured
    begin
      charge_options = {
        amount: customer_total_amount,
        currency: 'cad',
        customer: stripe_customer_id,
        # source: stripe_token,
        description: description,
        application_fee: service_fee,
        destination: {
          account: chef.payment_account.stripe_account
        },
        statement_descriptor: "Just Booked Order"
      }
      charge = Stripe::Charge.create(charge_options)
    rescue Stripe::CardError => e
      self.stripe_response = { errors: [e.message] }
      self.charge_attempts = charge_attempts + 1
      self.request_status = 'New'
      save!
    else
      if charge.present?
        self.stripe_response = charge.to_json
        self.captured = true
        self.charge_attempts = charge_attempts + 1

        self.brand = stripe_response['source']['brand']
        self.last4 = stripe_response['source']['last4']

        save!

        OrderMailer.accepted_order_customer(self).deliver
        OrderMailer.accepted_order_chef(chef, self).deliver

        a = Time.now
        b = self.order_time.to_time
        wait_hours = calc_wait_hours(DateTime.now.to_date, self.order_date.to_date, a, b)

        if wait_hours > 0
          OrderMailer.send_review_customer(chef, self).deliver_later!(wait_until: wait_hours.hours.from_now)
        end

      end
    end
  end

  def customer_total_amount
    chef_amount + service_fee
  end

  def calc_wait_hours(date_a, date_b, time_a, time_b)
    (date_b - date_a) * 24.0 + ((time_b - time_a) / 3600.0).ceil + 1
  end

  def charge_back

  end

  def failed?
    !captured? && stripe_response && stripe_response['errors'].present?
  end

  def order_desc
    "#{first_name} #{last_name}(#{email})"
  end

  def display_delivery_distance
    delivery_distance / 100
  end

  def menus
    purchase_items.where(model_type: 'Menu')
  end

  def addons
    purchase_items.where(model_type: 'Addon')
  end

  def payment_info
    if brand.present? && last4.present?
      "Payment Info: #{brand} **** **** **** #{last4}"
    elsif !brand.present? && last4.present?
      "Payment Info: **** **** **** #{last4}"
    else
      ""
    end
  end
  
  private

  # def charge_if_needed
  #   capture if booking.capture_now?
  # end

  # def send_charge_notification
  #   return unless captured
  #   [booking.sender, booking.recipient].each do |user|
  #     UserMailer.delay_for(
  #       5.seconds, queue: 'bookings_mailer', retry: true
  #     ).charge_notification(booking.id, user)
  #   end
  # end

  # def track_event
  #   return unless captured
  #   Tracker.track(
  #     (booking.sender ? booking.sender_id.to_s : 'guest'),
  #     'Payment charged', id: id)
  # end
end
