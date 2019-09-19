FactoryGirl.define do
  factory :charge do
    booking ""
amount ""
charge_at "2016-07-19"
charged false
charge_attempts 1
stripe_response ""
  end

end
