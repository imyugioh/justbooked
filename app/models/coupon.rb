class Coupon < ActiveRecord::Base
  validates :name, :card_token, :customer_id, :discount, :start_date, :end_date, presence: true
  validates :name, uniqueness: true
  has_many :used_coupons
  has_many :bookings, through: :used_coupons

  scope :available, -> { where(expired: false) }

  def available?(user_id)
    used_coupons = UsedCoupon.where(coupon_id: id, confirmed: true)
    used_by_user = used_coupons.where(user_id: user_id)
    limit_exceeded = used_coupons.size >= limit
    return false if limit_exceeded
    !used_by_user.any?
  end
end
