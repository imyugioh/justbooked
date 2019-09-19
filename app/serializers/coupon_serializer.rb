class CouponSerializer < ActiveModel::Serializer
  attributes :discount

  def discount
    object.discount.to_f / 100
  end
end
