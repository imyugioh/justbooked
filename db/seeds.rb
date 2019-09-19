# user = User.create!(
#   email: 'rmagnum2002@gmail.com',
#   password: 'admin2015',
#   password_confirmation: 'admin2015',
#   first_name: 'Sergiu',
#   last_name: 'Rosca',
#   confirmed_at: 1.day.ago
# )

# user1 = User.create!(
#   email: 'test@mail.com',
#   password: 'admin2015',
#   password_confirmation: 'admin2015',
#   first_name: 'John',
#   last_name: 'Doe',
#   confirmed_at: 1.day.ago
# )

user4 = User.create!(
  email: 'test1@test1.com',
  password: 'test1',
  password_confirmation: 'test1',
  first_name: 'sd',
  last_name: 'Kan',
  confirmed_at: 1.day.ago
)


cuisine_types = Tag.create!([
    {name: 'American', tag_type: 'cuisine_type'},
    {name: 'Asian', tag_type: 'cuisine_type'},
    {name: 'Breakfast', tag_type: 'cuisine_type'},
    {name: 'British', tag_type: 'cuisine_type'},
    {name: 'Bakery & Cafe', tag_type: 'cuisine_type'},
    {name: 'Burgers', tag_type: 'cuisine_type'},
    {name: 'Caribbean', tag_type: 'cuisine_type'},
    {name: 'Desserts', tag_type: 'cuisine_type'},
    {name: 'Greek', tag_type: 'cuisine_type'},
    {name: 'Canadian', tag_type: 'cuisine_type'},
    {name: 'Chinese', tag_type: 'cuisine_type'},
    {name: 'French', tag_type: 'cuisine_type'},
    {name: 'Healthy', tag_type: 'cuisine_type'},
    {name: 'Japanese', tag_type: 'cuisine_type'},
    {name: 'Korean', tag_type: 'cuisine_type'},
    {name: 'Indian', tag_type: 'cuisine_type'},
    {name: 'Mexican', tag_type: 'cuisine_type'},
])



dietary_types = Tag.create!([
    {name: 'Vegan', tag_type: 'dietary_type'},
    {name: 'Vegetarian', tag_type: 'dietary_type'},
    {name: 'Gluten-free', tag_type: 'dietary_type'},
    {name: 'Nut-free', tag_type: 'dietary_type'},
    {name: 'Allergy-friendly', tag_type: 'dietary_type'},
])


# Default chef header and profile image
Asset.create image: File.new("#{Rails.root}/public/images/chef/chef_placeholder_pic.png","r"), assetable_type: 'Chef', asset_detail: :chef_profile, token: SecureRandom.uuid
Asset.create image: File.new("#{Rails.root}/public/images/chef/chef_header_placeholder.png","r"), assetable_type: 'Chef', asset_detail: :chef_header, token: SecureRandom.uuid


venues = Venue.create!([
  {name: "Lowe-Barrows", description: "Nulla ratione et animi omnis sit dolores. Quibusdam voluptas vitae nesciunt quia ipsa rem. Labore quam quia. Fugit est nemo ut aut ut. Quasi voluptas quia. Est accusamus aperiam deleniti hic. Tempore est odit. Voluptatum nostrum praesentium. Provident ducimus doloremque. Unde similique et et magni voluptatem placeat ut. Optio culpa nemo sapiente sit. Autem id eveniet non voluptatem dolorum veritatis. Mollitia beatae ut. Nam suscipit incidunt. Illum nostrum repudiandae ea autem. Aperiam ipsa numquam velit.", user_id: 1, address: "6226 10 Line, Beeton, ON L0G 1A0, Canada", latitude: 44.1034424, longitude: -79.791255, street_address: "6226 10 Line", street_number: "6226", street_name: "10 Line", city: "New Tecumseth", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L0G 1A0", country_code: "CA", provider: "google", neighborhood: nil, district: "Simcoe County", country: "Canada", accuracy: "9", website: "toy.info", price: 14.17, capacity: 145},
  {name: "Auer, Shanahan and Feest", description: "Quam labore odit sint eum facere asperiores commodi. Veniam voluptatibus voluptatem minus ut aut nemo debitis. Sunt at voluptatem rerum vel quo. Qui et iusto autem quo et. Quia quam qui ut laboriosam ut deserunt. Illum culpa ab non excepturi est ipsa. Doloribus sint impedit repellendus et autem tempore. Quia consequuntur dicta sed pariatur. Voluptatem odit dicta. Libero qui fugiat voluptas asperiores molestiae laudantium et. Ut similique voluptatem necessitatibus debitis. Cumque eaque est voluptatem voluptate quas iure. Voluptatem minus corrupti. Saepe fugiat consequatur dicta error omnis.", user_id: 1, address: "5423-5445 Trafalgar Road North, Hillsburgh, ON N0B 1Z0, Canada", latitude: 43.747685, longitude: -80.0812749, street_address: "5445 Trafalgar Road North", street_number: "5445", street_name: "Trafalgar Road North", city: "Erin", state: "ON", state_code: "ON", state_name: "Ontario", zip: "N0B 1Z0", country_code: "CA", provider: "google", neighborhood: "Hillsburgh", district: "Wellington County", country: "Canada", accuracy: "8", website: "gusikowski.net", price: 22.47, capacity: 397},
  {name: "Gusikowski, Altenwerth and Bradtke", description: "Iste voluptatem eius earum minima est. Et nihil reiciendis. Vitae numquam est qui quae. Nam non et modi. Et inventore fugit. Omnis ut libero quod inventore et fugiat et. Qui corporis omnis. Earum mollitia vitae rerum fugit aperiam ut perspiciatis. Animi tenetur aut aut corrupti reiciendis error. Aut voluptas molestias dolores vel. Sunt ea animi ipsum tempora. Adipisci doloremque consequuntur. Nobis qui sint incidunt sapiente iusto repellendus. Autem nemo occaecati. Nam tempora fuga placeat ex. Quasi illum dolorem aut quis. Libero non non occaecati. Cumque ut necessitatibus qui.", user_id: 1, address: "5501-5613 Countryside Drive, Brampton, ON L6P, Canada", latitude: 43.8362955, longitude: -79.6890784, street_address: "5613 Countryside Drive", street_number: "5613", street_name: "Countryside Drive", city: "Brampton", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L6P", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "8", website: "huels.name", price: 47.56, capacity: 228},
  {name: "Bogan and Sons", description: "Incidunt id magni mollitia animi atque et eum. Consequatur quibusdam sed sapiente a. Eum ut ea excepturi suscipit id laboriosam et. Et quia vel velit culpa in quo mollitia. Rerum suscipit dicta. Sed nesciunt deleniti voluptates pariatur dolores autem aut. Sed aperiam aliquam sit molestiae sint commodi ut. Eaque ut harum rerum. Accusamus molestiae et error laboriosam sit soluta. Recusandae quia et perferendis aut sint. Hic dolore quis quibusdam. Maxime aperiam illo. Excepturi in commodi sed distinctio. Nihil ut doloribus delectus consequuntur.", user_id: 1, address: "19619 McCowan Road, Mount Albert, ON L0G 1M0, Canada", latitude: 44.1384912, longitude: -79.3473307, street_address: "19619 McCowan Road", street_number: "19619", street_name: "McCowan Road", city: "Mount Albert", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L0G 1M0", country_code: "CA", provider: "google", neighborhood: nil, district: "York Regional Municipality", country: "Canada", accuracy: "9", website: "lehner.info", price: 40.58, capacity: 229},
  {name: "Heidenreich Group", description: "Optio et pariatur est veritatis. Corrupti mollitia eum. Dolor a nam velit reiciendis. Esse quas non accusantium dolores ut quia. Doloribus optio quibusdam quod pariatur. Dolor sed voluptas distinctio. Sunt voluptas rerum sequi voluptatem tempore eligendi odit. Repellendus omnis adipisci qui minus harum. At aut non atque ut nam iste. Et architecto laboriosam non. Voluptatibus aperiam a veritatis repellat voluptatem et. Natus dolorem nobis consequatur atque. Enim itaque quaerat velit excepturi voluptatibus. Eligendi at iure deleniti iste ipsa. Eum voluptatem impedit molestiae occaecati. Est deserunt quas deleniti est. Occaecati perspiciatis nesciunt maiores deleniti. Atque in veritatis reiciendis vel. Hic dolores rem ut consequatur quia fugiat. Vitae qui reiciendis quisquam ut sint voluptatibus.", user_id: 1, address: "7588 4 Line, Wallenstein, ON N0B 2S0, Canada", latitude: 43.6579873, longitude: -80.6577664, street_address: "7588 4 Line", street_number: "7588", street_name: "4 Line", city: "Wallenstein", state: "ON", state_code: "ON", state_name: "Ontario", zip: "N0B 2S0", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "okon.net", price: 28.82, capacity: 311},
  {name: "Daniel Inc", description: "Porro ea sit velit quia et in voluptas. Autem ipsam eveniet. Qui esse in. Praesentium omnis laboriosam voluptatem ducimus eaque nam unde. Ut deleniti eius vitae qui. Aliquam sit ullam. Aut voluptatibus et vel recusandae sapiente quo. Et sed laborum. Aut deserunt nostrum vel consequatur quas voluptatem. Et et qui qui rerum. Est quia optio dolorem placeat velit rem. Et quo hic voluptatem tempore fuga. Qui labore natus modi. Dignissimos expedita deleniti architecto temporibus tempore sequi. Atque accusantium occaecati omnis est repudiandae optio accusamus. Beatae cum eius consequatur veniam qui maxime exercitationem. Minima vel soluta aut.", user_id: 1, address: "865 Second Line East, Sault Ste. Marie, ON P6B 4K5, Canada", latitude: 46.5385926, longitude: -84.3072715, street_address: "865 Second Line East", street_number: "865", street_name: "Second Line East", city: "Sault Ste. Marie", state: "ON", state_code: "ON", state_name: "Ontario", zip: "P6B 4K5", country_code: "CA", provider: "google", neighborhood: nil, district: "Algoma District", country: "Canada", accuracy: "9", website: "mertzbernhard.name", price: 65.72, capacity: 362},
  {name: "Greenholt, Marvin and Walter", description: "Quam voluptates non. Voluptatem doloribus sint non blanditiis. Qui et eum nulla. Eos at quo reiciendis atque et et. Deserunt nihil mollitia et nostrum labore vero illo. Repudiandae et nesciunt fugit. Consequatur quae quaerat modi itaque illo non tempore. Velit ut in dolor iusto repellat aliquam sint. Quis consequatur consequatur. Nesciunt explicabo totam repellat ut maxime corporis. Incidunt sit quas. Sint voluptas odit officia rerum et ipsa molestiae. Aperiam pariatur ut numquam. Nemo et amet possimus. Blanditiis ut doloremque velit minus. Ducimus sit veniam.", user_id: 1, address: "18 Oriole Crescent, Baltimore, ON K0K 1C0, Canada", latitude: 44.0159149, longitude: -78.1470968, street_address: "18 Oriole Crescent", street_number: "18", street_name: "Oriole Crescent", city: "Baltimore", state: "ON", state_code: "ON", state_name: "Ontario", zip: "K0K 1C0", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "kozey.org", price: 65.03, capacity: 281},
  {name: "7 Enoetca", description: "7 Enoteca is a casual restaurant that has limited seating; therefore, we cannot accept reservations. Seating is on a first come, first serve basis. If there is a wait when you arrive, we will be happy to take down your name and number and call you when your table is ready. There are many cafés and galleries in the area to enjoy while you wait for your table.", user_id: 1, address: "216 Lakeshore Rd. E, Oakville, Ontario", latitude: 43.4459328, longitude: -79.6677023, street_address: "216 Lakeshore Road East", street_number: "216", street_name: "Lakeshore Road East", city: "Oakville", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L6J 1H8", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "www.the7.ca", price: 37.07, capacity: 170},
  {name: "Turnberry Golf Club", description: "Our beautiful facilities are perfect for Weddings, Private Gatherings, Meetings, Special Events and Tournaments.", user_id: 1, address: "10100 Heart Lake Rd., Brampton, Ontario L6Z 0B4, Canada", latitude: 43.7230126, longitude: -79.7728557, street_address: "10100 Heart Lake Road", street_number: "10100", street_name: "Heart Lake Road", city: "Brampton", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L6Z", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.turnberrygolf.ca/home.htm", price: 21.31, capacity: 170},
  {name: "Wisozk-Johnson", description: "Aut officiis enim molestiae earum ut quos alias. Labore ut perferendis ad autem tempore. Et eos error blanditiis. Sed vero voluptatibus. Nostrum perspiciatis voluptates voluptatem. Magnam perspiciatis qui. Blanditiis magnam quisquam asperiores dolore repellendus rerum at. Mollitia eaque vero enim impedit ut ducimus. Aperiam qui libero nisi at earum. Adipisci est placeat rem explicabo. Quia dolore est harum. Ut sit id consequuntur ut voluptate vero occaecati. Id accusantium dolore expedita et aliquid. Consequuntur possimus doloribus recusandae error. Est dolor non rerum beatae. Id quia consequatur magnam. Optio blanditiis molestias. Nostrum deleniti beatae quod omnis natus est.", user_id: 1, address: "3429-3461 Albert's Alley, Cobourg, ON K9A 4J7, Canada", latitude: 44.0356062, longitude: -78.2222203, street_address: "3461 Albert's Alley", street_number: "3461", street_name: "Albert's Alley", city: "Cobourg", state: "ON", state_code: "ON", state_name: "Ontario", zip: "K9A 4J7", country_code: "CA", provider: "google", neighborhood: nil, district: "Northumberland County", country: "Canada", accuracy: "8", website: "tremblay.biz", price: 29.94, capacity: 345},
  {name: "Krajcik Inc", description: "Quia aliquid quia repudiandae rerum. Qui aut non. Alias magnam dolorem atque. Aut ducimus provident voluptas. Quo aliquid eaque repellendus ea eos qui. Culpa porro dolore possimus numquam voluptatibus perspiciatis rerum. Et quisquam earum amet voluptatem. Et occaecati exercitationem velit esse aut hic. Odio magni eos consequatur. Delectus et animi temporibus consectetur consequatur ut voluptatum. Repellat culpa aspernatur tempore numquam. Quae explicabo eum est qui voluptatem nobis. Consequatur laboriosam corporis aut aperiam. Omnis non dignissimos qui cupiditate voluptatem. Voluptatibus pariatur ullam repellendus. Itaque reprehenderit dolor. Qui dolorum quos alias voluptas maxime occaecati. Quo et aut ut voluptatem.", user_id: 1, address: "3054 McClelland Road, Port Hope, ON L1A 3V6, Canada", latitude: 44.005706, longitude: -78.277423, street_address: "3054 McClelland Road", street_number: "3054", street_name: "McClelland Road", city: "Port Hope", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L1A 3V6", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "dicki.name", price: 28.62, capacity: 289},
  {name: "Reilly-D'Amore", description: "Vel illo consequuntur sequi asperiores consequatur est. Ullam dolor eaque ex maxime laudantium dolorum. Quis nihil voluptatem doloribus assumenda quas ea. Dicta accusamus nihil dolorem eos inventore. Sit nemo voluptates et. Voluptate magnam assumenda. Harum ratione et. Et aut id nulla sit perferendis commodi repellendus. Voluptatum aut et autem nihil quam. Alias ullam corporis quo. Soluta aspernatur aut. Provident ea non sapiente exercitationem excepturi nisi. Saepe ipsa rerum facilis delectus. Officiis asperiores et vero. Sit dolor temporibus ad sed.", user_id: 1, address: "3351 Dundas Street West, Toronto, ON M6P 2A6, Canada", latitude: 43.6654916, longitude: -79.4819219, street_address: "3351 Dundas Street West", street_number: "3351", street_name: "Dundas Street West", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6P 2A6", country_code: "CA", provider: "google", neighborhood: "The Junction", district: "Toronto Division", country: "Canada", accuracy: "9", website: "kiehn.name", price: 57.83, capacity: 358},
  {name: "Skiles and Sons", description: "Error amet tenetur id pariatur animi iste ullam. Eum quaerat sed et et nemo nam. Velit quas deleniti sed molestias. Consequuntur reiciendis odio nostrum. Doloribus eos voluptates debitis. Dolorum mollitia velit porro animi ut quo repudiandae. Est nesciunt qui reprehenderit atque aut. Voluptatem odio modi perspiciatis quaerat sed ut iusto. Ad similique aspernatur culpa atque eaque tenetur. Molestiae id vitae rerum est. Quia veritatis ut sit repellat. Sint sit vel. Repellat incidunt libero error neque. Iste fugit maiores qui. Cupiditate consequatur facere officia hic labore impedit. Odit est rerum qui non repellendus est praesentium. Quia magni sunt. Et suscipit magnam in sit.", user_id: 1, address: "265 Runnymede Road, Toronto, ON M6S 2Y5, Canada", latitude: 43.6517513, longitude: -79.4759751, street_address: "265 Runnymede Road", street_number: "265", street_name: "Runnymede Road", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6S 2Y5", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "kaulke.com", price: 21.15, capacity: 342},
  {name: "Kutch-Langworth", description: "Quam labore sunt quae. Omnis voluptatem voluptatem nisi earum. Assumenda quo dolore eum consectetur sit consequatur. Eveniet ipsum id aut. Porro neque et ea occaecati deserunt fugiat doloremque. Voluptatum est aut voluptatibus. Ratione nihil delectus aliquid qui recusandae. Molestiae pariatur harum quis. Eveniet officiis fugit ex laudantium ea enim. Qui doloremque adipisci voluptate eos. Ea soluta voluptatem reprehenderit omnis laborum eum ducimus. Enim repellat nihil temporibus. Excepturi nostrum consequatur et asperiores. Non et fuga dicta quae dolores quas. Accusamus ea cumque et in. Facilis maxime quibusdam sint aliquam. Perspiciatis sunt quos.", user_id: 1, address: "349 Runnymede Road, Toronto, ON M6S 2Y5, Canada", latitude: 43.6546686, longitude: -79.4774569, street_address: "349 Runnymede Road", street_number: "349", street_name: "Runnymede Road", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6S 2Y5", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "jacobs.name", price: 24.82, capacity: 269},
  {name: "Sawayn, Upton and Howe", description: "Omnis consequatur quia est modi. Hic asperiores harum quo. Id dolorum odio. Enim possimus nam voluptas cumque. Distinctio error ex. Aspernatur repellendus eius aut similique voluptatibus quae voluptate. Minima maxime nulla corrupti. Necessitatibus aut dolores veritatis. Ea consequatur ut dolorem molestias nulla. Ipsum consequuntur ullam similique a labore officiis facere. Illo praesentium doloribus velit nostrum est. Maiores porro dolorum qui est assumenda quia. Voluptatum velit pariatur repellendus. Quasi necessitatibus dolore odit animi. Eligendi molestiae odio laborum dolores. Repudiandae veritatis culpa assumenda quod. Aut aliquam maiores. Nesciunt doloremque laborum ratione ut facere magni est. Officiis quis laborum.", user_id: 1, address: "648 Windermere Avenue, Toronto, ON M6S 3L8, Canada", latitude: 43.6565275, longitude: -79.4830193, street_address: "648 Windermere Avenue", street_number: "648", street_name: "Windermere Avenue", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6S 3L8", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "schaefer.name", price: 21.53, capacity: 333},
  {name: "Graham-Sipes", description: "Unde error et aliquam quia facilis voluptate. Eligendi dignissimos ipsa aut qui soluta. Nulla incidunt voluptatum illo. Sed sequi vitae. Quos quisquam quam voluptatum sint et reprehenderit veniam. Consequuntur quo ratione et aliquam. Nihil qui architecto numquam. Pariatur non quam nisi voluptatibus similique veniam culpa. Est magnam perspiciatis natus recusandae. Natus quis reiciendis. Sed sapiente voluptatem qui. Aut aliquam mollitia labore nisi eos odit corrupti. Ipsam rerum esse numquam hic. Est ut officia id iure eum. Sed sunt hic non neque amet.", user_id: 1, address: "360 Armadale Avenue, Toronto, ON M6S 3X8, Canada", latitude: 43.6533532, longitude: -79.4849648, street_address: "360 Armadale Avenue", street_number: "360", street_name: "Armadale Avenue", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6S 3X8", country_code: "CA", provider: "google", neighborhood: "Runnymede", district: "Toronto Division", country: "Canada", accuracy: "8", website: "bauch.info", price: 35.49, capacity: 316},
  {name: "Medhurst-Pagac", description: "Ut dolorem ipsa repellat. Sed officiis molestias velit. Perferendis sit similique nisi consequatur alias libero et. Aspernatur repellat similique neque. Voluptatem beatae commodi. Distinctio ex suscipit molestias sit esse iure repellat. At illo quisquam saepe autem enim temporibus est. Minima sed necessitatibus consequuntur asperiores quasi non. Qui provident cupiditate. Consequatur consequatur soluta sunt et quia ut. Voluptatem ut voluptatibus sed sapiente vitae quo impedit. Unde natus impedit voluptates magnam earum. Soluta quam ipsa eligendi quidem nihil. Neque et ipsa sint. Eos labore illo reiciendis.", user_id: 1, address: "Old Weston Road, Toronto, ON M6N, Canada", latitude: 43.6694077, longitude: -79.4618048, street_address: "Old Weston Road", street_number: "", street_name: "Old Weston Road", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6N", country_code: "CA", provider: "google", neighborhood: nil, district: "Toronto Division", country: "Canada", accuracy: "5", website: "bartell.name", price: 20.84, capacity: 108},
  {name: "&Company Resto Bar", description: "Life is about the interaction between you, your circle and your environment. &Company Resto Bar, steps away from the Square One Shopping Center in Mississauga, is the local hotspot for you to feed your social appetite. Join us for an elevated culinary experience curated by Executive Chef Ron Stratton, then stay for the bustling nightlife that follows. Life's better when you're in good company.", user_id: 1, address: "295 Enfield Place, Mississauga, ON L5B 3J4, Canada", latitude: 43.590786, longitude: -79.6365971, street_address: "295 Enfield Place", street_number: "295", street_name: "Enfield Place", city: "Mississauga", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L5B 3E2", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "8", website: "www.andcompany.ca", price: 75.66, capacity: 271},
  {name: "2nd Floor", description: "Whether you’re hosting a wedding, corporate function, concert, art show, fashion show, photo shoot, or social gathering (mitzvahs, engagements, reunions, anniversaries, auntie Mildred's 90th), 2nd Floor is ready to accommodate you and your events needs.", user_id: 1, address: "639 Queen St W, Toronto, ON M5V 2B7, Canada", latitude: 43.6471805, longitude: -79.4034034, street_address: "639 Queen Street West", street_number: "639", street_name: "Queen Street West", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M5V 2B7", country_code: "CA", provider: "google", neighborhood: "Queen Street West", district: "Toronto Division", country: "Canada", accuracy: "9", website: "www.2ndfloorevents.com", price: 12.10, capacity: 126},
  {name: "99 Sudbury", description: "Throughout the years, 99 Sudbury has gone through many changes. Widely recognized as home to a restored glass factory, critically acclaimed restaurants, Studio 99 Film Studios, and even a famed after-hours club. The most recent ventures, a fitness club and an event space, have grown magnificently over the years and 99 Sudbury has had the pleasure of welcoming guests like Google, Facebook, Lady Gaga, Benicio Del Toro, J Cole, Mustang, Q-Tip and Valentino.", user_id: 1, address: "99 Sudbury St Toronto, ON M6J 3S7, Canada", latitude: 43.6410712, longitude: -79.4226017, street_address: "99 Sudbury Street", street_number: "99", street_name: "Sudbury Street", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6J 3S7", country_code: "CA", provider: "google", neighborhood: nil, district: nil, country: "Canada", accuracy: "9", website: "www.99sudbury.ca", price: 16.69, capacity: 115},
  {name: "Cambium Farms", description: "Nestled on 50 acres in the heart of the picturesque Caledon hills since the early 1800's, Cambium Farms has retained all of its original charm. Featuring an awe inspiring, authentic, century old barn; a fully restored Farm and Carriage House, Cambium Farms is perfect for any event, large or small.", user_id: 1, address: "81 Charleston Sideroad, Caledon, Ontario L0N 1C0, Canada", latitude: 43.8039708, longitude: -80.0577089, street_address: "81 Charleston Sideroad", street_number: "81", street_name: "Charleston Sideroad", city: "Caledon", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L0N", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "8", website: "www.cambiumfarms.com", price: 74.1, capacity: 357},
  {name: "Copper Creek Colf Course", description: "Copper Creek offers you spectacular amenities conveniently located in the town of Kleinburg. World-class dining and an immaculate event venue overlook a breathtaking view of one of the top public golf courses in Canada. Allow our professional staff to cater to your every need, whether it be for an important business lunch, a family gathering or your dream wedding. Come visit us today and see what spectacular truly means.", user_id: 1, address: "11191 Highway 27, Kleinburg, ON L0J 1C0, Canada", latitude: 43.8603733, longitude: -79.6428334, street_address: "11191 Highway 27", street_number: "11191", street_name: "Highway 27", city: "Vaughan", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L0J", country_code: "CA", provider: "google", neighborhood: nil, district: "York Regional Municipality", country: "Canada", accuracy: "8", website: "www.coppercreek.ca", price: 39.0, capacity: 166},
  {name: "Fanzorelli's", description: "Let us do the cooking for you any day of the week. Whether you are craving fresh pasta, stone oven pizza or antipasto, Fanzorelli's Restaurant & Wine Bar in Brampton can offer dine in or take-out for their entire menu.", user_id: 1, address: "50 Queen St. West, Brampton, ON, L6X 4H3, Canada", latitude: 43.6851342, longitude: -79.7612494, street_address: "50 Queen Street West", street_number: "50", street_name: "Queen Street West", city: "Brampton", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L6X 0T6", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.fanzorellis.ca", price: 54.96, capacity: 260},
  {name: "Kingbirdge Conference Centre & Institution", description: "Kingbridge is a unique residential Conference Centre and full-service hospitality venue designed specifically for leaders who want to work with their teams to expand their thinking and inspire change. To us, the traditional methods for engaging during meetings was missing something, so we created a specialized place where the focus is solely dedicated to meeting and learning.", user_id: 1, address: "12750 Jane Street King City, Toronto, Ontario L7B 1A3, Canada", latitude: 43.9169463, longitude: -79.5556511, street_address: "12750 Jane Street", street_number: "12750", street_name: "Jane Street", city: "King City", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L7B 1A3", country_code: "CA", provider: "google", neighborhood: nil, district: "York Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.kingbridgecentre.com/", price: 47.83, capacity: 124},
  {name: "Monte Casino", description: "Montescassino's dedicated team of managers and event specialists will make only the best catering recommendations to suit the mood and theme of your function.", user_id: 1, address: "3710 Chesswood Drive, Downsview, Ontario M3J 2W4, Canada", latitude: 43.7559457, longitude: -79.4746318, street_address: "3710 Chesswood Drive", street_number: "3710", street_name: "Chesswood Drive", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M3J 2W4", country_code: "CA", provider: "google", neighborhood: "York University Heights", district: "Toronto Division", country: "Canada", accuracy: "9", website: "montecassino.on.ca/", price: 44.78, capacity: 300},
  {name: "Paradise Banquet Halls", description: "Step into a dream come true as you enter the fairy tale surroundings of Paradise Banquet Hall. Choose from several  venue spaces dressed with our elegant backdrops and enjoy our outdoor garden with Victorian bridge and stunning atrium surrounding our European gazebo. For over 40 years, Paradise has taken pride as one of Canada’s leaders in European and Multicultural cuisine and has been voted as #1 for Product and Service by York Region.", user_id: 1, address: "7601 JANE STREET, VAUGHAN, ON L4K 1X2, Canada", latitude: 43.7913049, longitude: -79.5226485, street_address: "7601 Jane Street", street_number: "7601", street_name: "Jane Street", city: "Vaughan", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L4K 1X2", country_code: "CA", provider: "google", neighborhood: "Concord", district: "York Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.paradisebanquethalls.com/social/", price: 95.84, capacity: 319},
  {name: "Palais Royale", description: "For 92 years the Palais Royale has been home to great musicians such as Count Basie and Duke Ellington. In 2005 Palais Royale underwent a revival and now takes its place as one of Toronto’s premier event venues. ", user_id: 1, address: "1601 Lake Shore Blvd. West, Toronto, ON, M6K 3C1, Canada", latitude: 43.6367005, longitude: -79.4471754, street_address: "1601 Lake Shore Boulevard West", street_number: "1601", street_name: "Lake Shore Boulevard West", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: "M6K 3C1", country_code: "CA", provider: "google", neighborhood: "Sunnyside", district: "Toronto Division", country: "Canada", accuracy: "9", website: "http://www.palaisroyale.ca/", price: 16.54, capacity: 342},
  {name: "Riverstone Golf", description: "Whether it's an intimate gathering for close friends and family or a lavish celebration, Riverstone Golf & Country Club will impress your guests with flawless service, an exquisite menu and awe-inspiring vistas. ", user_id: 1, address: "195 Don Minaker Drive, Brampton, ON L6P 2V1, Canada", latitude: 43.7659276, longitude: -79.6708689, street_address: "195 Don Minaker Drive", street_number: "195", street_name: "Don Minaker Drive", city: "Brampton", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L6P 2V1", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.riverstonegolf.com/club/home", price: 11.72, capacity: 139},
  {name: "Oakdale Golf", description: "Founded in 1926, Oakdale Golf & Country Club is widely recognized as one of Canada’s finest private golf and country clubs. Oakdale’s vibrant membership community enjoys a world class 27 hole championship golf course, beautiful clubhouse and exquisite dining facilities. We offer a family oriented atmosphere with many programs, social activities and high-end amenities such as an Olympic sized swimming pool, tennis courts, fitness facilities and on-site aesthetic and massage services.", user_id: 1, address: "2388 Jane St, Toronto, ON, Canada", latitude: 43.7318016, longitude: -79.511264, street_address: "2388 Jane Street", street_number: "2388", street_name: "Jane Street", city: "Toronto", state: "ON", state_code: "ON", state_name: "Ontario", zip: nil, country_code: "CA", provider: "google", neighborhood: "Downsview", district: "Toronto Division", country: "Canada", accuracy: "8", website: "http://oakdalegolf.com/", price: 44.21, capacity: 107},
  {name: "The International Centre", description: "Bright, modern and dynamic – our $7 million renewal plan will enhance over 500,000 sq ft. of event space, making your experience here even better.", user_id: 1, address: "6900 Airport Road, Mississauga, Ontario L4V 1E8, Canada ", latitude: 43.7032645, longitude: -79.6376699, street_address: "6900 Airport Road", street_number: "6900", street_name: "Airport Road", city: "Mississauga", state: "ON", state_code: "ON", state_name: "Ontario", zip: "L4V 1E8", country_code: "CA", provider: "google", neighborhood: nil, district: "Peel Regional Municipality", country: "Canada", accuracy: "9", website: "http://www.internationalcentre.com/home.html", price: 68.64, capacity: 250}
])

# 20.times do |i|
#   tags = ['Social Event', 'Golf Event', 'Wedding', 'Networking event', 'Annual General Meeting',
#                           'Board Meeting', 'Business Dinners & Banquet', 'Product Launch', 'Theme Party',
#                           'Conference', 'Convention', 'Fairs', 'Galas', 'Executive Retreat', 'Press Conference', 'Political Event',
#                           'Reception', 'Seminar', 'Trade Show', 'Workshop']
#   a =Article.new(
#     title: Faker::Lorem.sentence,
#     content: Faker::Lorem.paragraphs(4, true),
#     published_at: Time.zone.now,
#     admin_user_id: AdminUser.first,
#     tag_list: tags.sample(2).join(', ')
#   )
#   a.save(validate: false)
#   Asset.create!([
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:43:11"},
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:14"},
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:43:16"},
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:18"},
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:43:21"},
#     {assetable_id: a.id, assetable_type: "Article", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:43:23"},
#   ])
# end

Asset.create!([
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:43:07"},
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:43:11"},
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:14"},
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:43:16"},
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:18"},
  {assetable_id: 1, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:43:21"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:43:23"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:43:25"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:28"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:43:30"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:43:33"},
  {assetable_id: 2, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:43:35"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:43:38"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:43:40"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:43:43"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:43:46"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:43:48"},
  {assetable_id: 3, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:43:51"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:43:53"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:43:55"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:43:58"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:44:01"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:44:04"},
  {assetable_id: 4, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:44:06"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:44:08"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:44:11"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:44:15"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:44:17"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:44:22"},
  {assetable_id: 5, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:44:25"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:44:29"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:44:32"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:44:34"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:44:37"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:44:40"},
  {assetable_id: 6, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:44:43"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:44:45"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:44:48"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:44:52"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:44:54"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:44:57"},
  {assetable_id: 7, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:44:59"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:45:02"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:45:04"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:45:06"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:45:09"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:45:11"},
  {assetable_id: 8, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:45:14"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:45:17"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:45:19"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:45:22"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:45:26"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:45:28"},
  {assetable_id: 9, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:45:31"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:45:33"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:45:36"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:45:38"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:45:41"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:45:43"},
  {assetable_id: 10, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:45:45"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:45:47"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:45:50"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:45:53"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:45:55"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:45:58"},
  {assetable_id: 11, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:00"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:02"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:05"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:46:07"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:09"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:46:11"},
  {assetable_id: 12, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:46:13"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:46:15"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:18"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:46:20"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:23"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:26"},
  {assetable_id: 13, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:46:28"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:31"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:46:33"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:46:36"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:46:38"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:46:41"},
  {assetable_id: 14, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:44"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:46:46"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:49"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:46:51"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:46:53"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:46:55"},
  {assetable_id: 15, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:46:58"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:47:00"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:47:03"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:47:05"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:47:08"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:47:11"},
  {assetable_id: 16, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:47:14"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:47:16"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:47:18"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:47:20"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:47:23"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:47:26"},
  {assetable_id: 17, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:47:30"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:47:32"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:47:35"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:47:37"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:47:40"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:47:43"},
  {assetable_id: 18, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:47:45"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:47:48"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:47:50"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:47:53"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:47:56"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:47:58"},
  {assetable_id: 19, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:48:01"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:48:03"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:48:06"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:48:08"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:48:11"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:48:13"},
  {assetable_id: 20, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:48:16"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:48:18"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:48:22"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:48:24"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:48:26"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:48:29"},
  {assetable_id: 21, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:48:31"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:48:36"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:48:38"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:48:40"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:48:43"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:48:45"},
  {assetable_id: 22, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:48:47"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:48:50"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:48:53"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:48:55"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:48:57"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:49:00"},
  {assetable_id: 23, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:49:02"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:49:05"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:49:07"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:49:09"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:49:12"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:49:14"},
  {assetable_id: 24, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:49:17"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:49:19"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:49:23"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:49:25"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:49:27"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:49:29"},
  {assetable_id: 25, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:49:31"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:49:34"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:49:39"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:49:41"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:49:44"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:49:47"},
  {assetable_id: 26, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:49:49"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:49:52"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:49:54"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:49:57"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg3.jpg", image_content_type: "image/jpeg", image_file_size: 151709, image_updated_at: "2015-07-10 15:50:00"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:50:02"},
  {assetable_id: 27, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:50:05"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:50:07"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:50:10"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:50:12"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:50:15"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:50:18"},
  {assetable_id: 28, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:50:21"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:50:23"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:50:26"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:50:28"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:50:31"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:50:34"},
  {assetable_id: 29, assetable_type: "Venue", image_file_name: "lg4.jpg", image_content_type: "image/jpeg", image_file_size: 181934, image_updated_at: "2015-07-10 15:50:37"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg7.jpg", image_content_type: "image/jpeg", image_file_size: 278393, image_updated_at: "2015-07-10 15:50:39"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg6.jpg", image_content_type: "image/jpeg", image_file_size: 1139341, image_updated_at: "2015-07-10 15:50:42"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg2.jpg", image_content_type: "image/jpeg", image_file_size: 152433, image_updated_at: "2015-07-10 15:50:47"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg5.jpg", image_content_type: "image/jpeg", image_file_size: 282620, image_updated_at: "2015-07-10 15:50:49"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:50:52"},
  {assetable_id: 30, assetable_type: "Venue", image_file_name: "lg1.jpg", image_content_type: "image/jpeg", image_file_size: 324360, image_updated_at: "2015-07-10 15:50:54"}
])

venues.each do |v|
  unless v.assets.any?
    6.times do
      i = Array(1..7).sample
      Asset.create(
        image: File.new("#{Rails.root}/db/seed/lg#{i}.jpg"),
        assetable_type: 'Venue',
        assetable_id: v.id
      )
    end
  end
end

venues.each do |venue|
  venue_types = ['Convention Centres', 'Restaurants', 'Banquet Halls', 'Country Clubs', 'Golf Clubs', 'Hotels', 'Office Buildings', 'Unique Venues']
  venue.venue_type_list = venue_types.sample(2).join(', ')
  venue.save
end

venues.each do |venue|
  event_types = ['Social Event', 'Golf Event', 'Wedding', 'Networking event', 'Annual General Meeting',
                          'Board Meeting', 'Business Dinners & Banquet', 'Product Launch', 'Theme Party',
                          'Conference', 'Convention', 'Fairs', 'Galas', 'Executive Retreat', 'Press Conference', 'Political Event',
                          'Reception', 'Seminar', 'Trade Show', 'Workshop']
  venue.event_type_list = event_types.sample(2).join(', ')
  venue.save
end

venues.each do |venue|
  amenities = ['A/V Equipment', 'Byob', 'Beachfront', 'Catering available', 'Coat check', 'Full bar', 'Great views',
                        'Handicap accesible', 'Indoor', 'Media room', 'Non smoking', 'Pool', 'Rooftop', 'Parking', 'Theater', 'Wi-fi']
  venue.amenity_list = amenities.sample(6).join(', ')
  venue.save
end
Venue.all.update_all(listed: true)

Venue.all.each do |v|
  3.times do
    min = Array(50..100).sample
    max = min + 50
    start_date = Date.today + Array(1..7).sample
    end_date = start_date + 1.month
    v.packages.new(
      title: Faker::Name.title, description: Faker::Lorem.paragraphs(
        1, true
      ).join, date_range: {
        start_date: start_date.to_s, end_date: end_date.to_s
      }, attendees: {
        min: min.to_s, max: max.to_s
      }
    ).save
  end
end
