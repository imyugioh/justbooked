class Account < ActiveRecord::Base
  belongs_to :user

  after_create :create_stripe_account

  def create_stripe_account
    acc = Stripe::Account.create(
      email: user.email, country: 'CA', type: 'custom')
    update_attributes(
      stripe_account:     acc.id,
      stripe_secret:      acc.keys.secret,
      stripe_publishable: acc.keys.publishable)
  end
end
