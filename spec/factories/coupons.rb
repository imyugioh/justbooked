FactoryGirl.define do
  factory :coupon do
    discount 5000
    name 'new discount'
    card_token 'card_stripe_token'
    customer_id 1
    start_date Date.today
    end_date Date.today + 10
    limit 5
  end
end
