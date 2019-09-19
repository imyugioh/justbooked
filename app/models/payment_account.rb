class PaymentAccount < ActiveRecord::Base
  belongs_to :chef
  belongs_to :user
  after_create :create_stripe_account
  after_save :update_stripe_info

  attr_accessor :stripe_terms_of_services, :ip_address
  
  AVAILABLE_CURRENCY = ['CAD','USD']
  BUSINESS_TYPES = ['individual','company']


  validates :user_id, :chef_id, :first_name, :last_name, presence: true
  validates :currency, :account_number, :routing_number, :business_type, presence: true
  validate :tos_accepted
  
  after_initialize do |user|
    stripe_object
  end

  def tos_accepted
    if self.stripe_terms_of_services == '1'
      stripe_accepted = true
    else
      errors.add(:stripe_terms_of_services, "must be accepted")
    end
  end
  
  
  def self.currency_options
    AVAILABLE_CURRENCY.collect { |currency| [currency, currency]}
  end

  def self.business_type_options
    BUSINESS_TYPES.collect { |btype| [btype.capitalize, btype]}
  end
  
  def stripe_account_id
    ENV['APP_SHORT_NAME'] + '_chef_' + chef_id.to_s
  end

  def has_stripe_account?
    # if stripe_account && stripe_secret && stripe_publishable
    if stripe_account.present?
      true
    else
      false
    end
  end


  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end


  def stripe_object
    if stripe_account
      begin
        @acc ||= Stripe::Account.retrieve(stripe_account)
      rescue => e
        puts "!!!!!!!!!!!! Can not retrieve stripe account"
        ap e
      end
    else
      nil
    end
  end

  def stripe_entity
    @entity ||= @acc.legal_entity
  end

  def unverified?(entity)
    entity.verification.status == 'unverified'
  end


  def create_stripe_account
    unless has_stripe_account?
      begin
        @acc = Stripe::Account.create(
          email: chef.email, 
          country: 'CA', 
          type: 'custom')

        accept_stripe_agreement

        # byebug

        update_columns({
          stripe_account: @acc.id,
          stripe_response: @acc.to_json
          # stripe_secret: @acc.keys.secret,
          # stripe_publishable: @acc.keys.publishable  
        })
        puts "updated strip account"
        ap @acc
      rescue => e
        puts "!!!!!!!!!!!! Can not create stripe account"
        ap e
      end
    end
  end

  # If you want to manually accept on console
  # pa = PaymentAccount.find 1
  # pa.stripe_terms_of_services = '1'
  # pa.ip_address  = '192.168.0.01'
  def accept_stripe_agreement
    if !stripe_accepted && ip_address.present?
      @acc.tos_acceptance.date = Time.zone.now.to_i
      @acc.tos_acceptance.ip = ip_address
      @acc.save
      puts ">>>>>>> stripe accepted"
    end
  end


  def has_external_bank_info
    if account_number.present? && routing_number.present? && first_name.present? && last_name.present?
      true
    else
      false
    end
  end
  
  def has_dob
    if dob_day && dob_month && dob_year
      true
    else
      false
    end
  end


  def external_accounts
    @acc.external_accounts.data.collect { |d| d.id}
  end


  def update_stripe_info

    unless has_stripe_account?
      create_stripe_account
    end

    if @acc
      puts "updating strip business/personal info"
      entity = @acc.legal_entity

      if business_name.present?
        @acc.business_name = business_name
        entity.business_name = business_name
      end

      if first_name.present?
        entity.first_name = first_name
      else
        entity.first_name = nil
      end

      if last_name.present?
        entity.last_name = last_name
      else
        entity.last_name = nil
      end

      if business_type.present?
        entity.type = business_type
      else
        entity.type = nil
      end
      
      if business_tax_id.present?
        entity.business_tax_id = business_tax_id
      else
        entity.business_tax_id = nil
      end
      
      if has_dob
        entity.dob.year = dob_year
        entity.dob.month = dob_month
        entity.dob.day = dob_day
      end

      address_info = entity.address

      if chef.address1.present?
        address_info.line1 = chef.address1
      else
        address_info.line1 = nil
      end

      if chef.address2.present?
        address_info.line2 = chef.address2
      else
        address_info.line2 = nil
      end

      if chef.city.present?
        address_info.city = chef.city
      else
        address_info.city = nil
      end

      if chef.state_code.present?
        address_info.state = chef.state_code
      else
        address_info.state = nil
      end

      if chef.zip.present?
        address_info.postal_code = chef.zip
      else
        address_info.postal_code = nil
      end

      @acc.save

      if has_external_bank_info
        manage_external_bank_account
      end

      accept_stripe_agreement      

    else
      puts ">>> no stripe information"
    end
  end

  private

  def manage_external_bank_account
    # Can not delete default account.
    # So creat a new one first, and delte later
    to_be_deleted = external_accounts

    # pa.stripe_object.external_accounts.create({:external_account => {
    #   default_for_currency: true,
    #   object: 'bank_account',
    #   account_holder_name: 'Steve Cho',
    #   account_holder_type: 'company',
    #   country: 'CA',
    #   currency: 'CAD',
    #   account_number: '000123456789',
    #   routing_number: '11000-000' 
    #   }}
    # )

    # Thenc create new
    begin
      params = {
        default_for_currency: true,
        object: 'bank_account',
        account_holder_name: "#{first_name} #{last_name}",
        account_holder_type: business_type,
        country: 'CA',
        currency: 'CAD',
        account_number: account_number
      }

      if routing_number.present?
        params[:routing_number] = routing_number
      end

      @acc.external_accounts.create({external_account: params})      

      to_be_deleted.each do |account|
        @acc.external_accounts.retrieve(account).delete
        puts ".. deleted #{account}"
      end

    rescue Stripe::InvalidRequestError => e
      puts ">>>> managing bank account error"
      ap params
      puts e.message
      errors.add(:base, e.message)
    end
    # refresh Strip object
    if stripe_account.present?
      puts ".. created external_accounts #{external_accounts}"
      @acc = Stripe::Account.retrieve(stripe_account)
    end
  end
end
