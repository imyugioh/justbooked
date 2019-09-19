namespace :dev do
  desc "Clean data related to chef signup"
  task clean_chef: :environment do
    if Rails.env == 'development'
      Chef.delete_all
      Asset.delete_all
      puts "........ data cleaned"
    end
  end
end
