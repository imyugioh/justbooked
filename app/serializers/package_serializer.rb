class PackageSerializer < ActiveModel::Serializer
  attributes :title,
             :auto_accept_limit,
             :description,
             :date_range,
             :attendees,
             :price,
             :weekdays,
             :amenity_list,
             :appetizer_list,
             :drink_list,
             :desert_list,
             :food_item_list,
             :slug,
             :urls,
             :permissions,
             :fixed_price

  def fixed_price
    object.fixed_price.to_s
  end

  def price
    {
      regular: object.regular_price,
      with_discount: object.discount_price,
      new_price: object.discount_price?,
      gratuity: object.gratuity
    }
  end

  def attendees
    { min: object.attendees_min, max: object.attendees_max }
  end

  def date_range
    { end_date: object.date_end, start_date: object.date_start }
  end

  def permissions
    user = serialization_options[:user]
    { can_edit: user.present? && user == object.user }
  end

  def urls
    { edit: edit_url, book: book_url, venue: venue_url }
  end

  def edit_url
    [
      '/chef',
      object.venue.slug,
      'packages',
      object.slug,
      'edit'
    ].join('/')
  end

  def venue_url
    ['/chef', object.venue.slug].join('/')
  end

  def book_url
    [
      '/chef', object.venue.slug,
      'packages', object.slug,
      'book_now'
    ].join('/')
  end
end
