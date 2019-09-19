FactoryGirl.define do
  factory :booking do |f|
    sender_id 1
    recipient_id 2
    package_id 1
    first_name 'John'
    last_name 'Doe'
    email 'test@mail.com'
    arrival_time '09:00 AM'
    date_start '2017-03-28'
    event_type 'Dining Out'
    estimated_guests_count 10
    package_info "{}"
    # f.package_info "{ "id"=>1, "venue_id"=>4, "title"=>"Delicious package", "description"=>"You may choose between \r\n- Margherita Pizza, \r\n- Chicken Wrap & Fries, \r\n- Nachos \r\n- Old Mill Wings.\r\n\r\nEach dish comes with a choice of pop.", "weekdays"=>{"friday"=>true, "monday"=>true, "sunday"=>true, "tuesday"=>true, "saturday"=>true, "thursday"=>true, "wednesday"=>true}, "created_at"=>"2016-08-26T17:13:36.564-04:00", "updated_at"=>"2017-03-25T17:46:30.490-04:00", "slug"=>"delicious-package", "user_id"=>1, "date_start"=>"2016-08-27T08:00:00.000-04:00", "date_end"=>"2017-08-30T04:00:00.000-04:00", "regular_price"=>"6.75", "discount_price"=>"4.99", "attendees_min"=>1, "attendees_max"=>24, "gratuity"=>10, "discount"=>"26.07", "expired"=>false, "book_on_site"=>true, "auto_accept_limit"=>20, "fixed_price"=>false, "food_items"=>["main1"], "amenities"=>["rooftop", "wi-fi", "non smoking", "coat check"], "appetizers"=>["app1"], "deserts"=>["dessert1"], "drinks"=>["drinks1"] }"
  end
end
