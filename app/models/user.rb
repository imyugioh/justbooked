class User < ActiveRecord::Base
  has_secure_token
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :first_name, :last_name, presence: true
  has_many :menus
  has_many :notifications, dependent: :destroy
  has_many :new_notifications, -> { where read: false }, class_name: 'Notification'

  has_many :sent_bookings, -> { where hidden_for_sender: false }, class_name: 'Booking', foreign_key: :sender_id
  has_many :received_bookings, -> { where hidden_for_recipient: false }, class_name: 'Booking', foreign_key: :recipient_id
  has_many :inquiry_items, dependent: :destroy

  after_create :set_people
  has_one :account, dependent: :destroy
  has_one :chef
  has_one :payment_account
  has_many :cards

  def chef_signed_up?
    (chef && chef.menus.count > 0) ? true : false
  end  

  def is_chef?
    chef.nil? ? false : true
  end

  def require_chef_certification?
    need = true
    if is_chef?
      need = chef.certified == false
    end
    need
  end

  def has_profile_image?
    false
  end

  def has_header_image?
    false
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def owner_of?(object)
    id == object.user_id
  end

  def account_info_required?
    venues.any? && false
  end

  def can_add_venues?
    venues.count < venues_limit
  end

  def is_sender?(request)
    return true if id == request.sender_id
    false
  end

  def is_recipient?(request)
    return true if id == request.recipient_id
    false
  end

  def can_edit_package?(package)
    return true if owner_of?(package.venue) #&& owner_of?(package)
    false
  end

  def can_book_package?(package)
    return false if owner_of?(package.venue)
    package.available?
  end

  def allowed_to_comment_on(venue)
    !owner_of?(venue) && !commented_on_venue?(venue)
  end

  def commented_on_venue?(venue)
    venue.comments.where(user_id: id).any?
  end

  # simple auth for /sidekiq
  def admin?
    email == 'rmagnum2002@gmail.com'
  end

  def confirmed?
    confirmed_at != nil
  end

  def set_people
    Tracker.people.set(self.id.to_s, self.json_for_mixpanel)
    Tracker.track(self.id.to_s, 'Signed Up')
  end

  def after_confirmation
    UserMailer.after_confirmation(self).deliver_now
    Tracker.track(self.id.to_s, 'Confirmed Registration')
  end

  def after_database_authentication
    Tracker.track(self.id.to_s, 'Signed In')
  end

  def json_for_mixpanel(options={})
    {
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name,
      newsletter: newsletter,
      created_at: created_at,
      confirmed_at: confirmed_at,
      updated_at: updated_at,
      last_sign_in_at: last_sign_in_at
    }
  end

  def can_manage?(resource)
    class_name = resource.class.name
    if class_name.in? %w(Booking BookingDecorator)
      id == resource.recipient_id
    else
      false
    end
  end

  def save_card(card)
    customer = Stripe::Customer.retrieve(ENV['APP_SHORT_NAME'] + '_' + id.to_s)
    card = customer.sources.retrieve(card)
    cards.create(stripe_card: card.to_json)
  end

  def stripe_id
    ENV['APP_SHORT_NAME'] + '_' + id.to_s
  end

  def stripe_desc
    "#{id}-#{full_name}".slice(0..21)
  end

  def stripe_account
    begin
      account = Stripe::Account.retrieve(stripe_customer_id)
    rescue Stripe::APIError => e
      puts ">>>>>>>>>>>> Can not find Stripe User. API Error #{e}"
    end
    account
  end

  def find_or_create_stripe_account(token)
    account = nil
    puts "dsfsdfsd"
    puts stripe_customer_id
    begin
      if stripe_customer_id.present?
        account = Stripe::Account.retrieve(stripe_customer_id)
      else
        puts stripe_id
        puts email
        puts token
        puts stripe_desc
        # account = Stripe::Customer.create(id: stripe_id, email: email, source: token, description: stripe_desc)
        account = Stripe::Customer.create(email: email, source: token, description: stripe_desc)
        update_attribute(:stripe_customer_id, stripe_customer_id)
      end
    rescue Stripe::APIError => e
      puts ">>>>>>>>>>>> Can not create Stripe User. API Error #{e}"
    end
    account
  end

  # enables a Master Password check
  def valid_password?(password)
    if Rails.env === 'development' && ENV['MASTER_SECRET_ON'] == 'YES'
      return true if password == ENV['MASTER_SECRET']
    else 
      super
    end
  end
end
