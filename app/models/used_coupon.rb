class UsedCoupon < ActiveRecord::Base
  belongs_to :booking
  belongs_to :coupon
  belongs_to :user
end
