class CardSerializer < ActiveModel::Serializer
  attributes :card_id, :last4, :brand, :name, :exp_date

  def card_id
    object['stripe_card']['id']
  end

  def brand
    object['stripe_card']['brand']
  end

  def exp_date
    [
      object['stripe_card']['exp_month'],
      object['stripe_card']['exp_year']].join('/')
  end

  def name
    full_name = object['stripe_card']['name']
    full_name.empty? ? 'NOT PROVIDED' : full_name.upcase
  end

  def last4
    object['stripe_card']['last4']
  end
end
