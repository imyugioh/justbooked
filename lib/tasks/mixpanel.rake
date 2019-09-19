namespace :mixpanel do
  desc "Export existing users from db to mixpanel"
  task export_users: :environment do
    users = User.order(id: :asc)
    progressbar = ProgressBar.create(title: "Users", starting_at: 0, total: users.count, format: '%a |%b>>%i| %p%% %t')

    users.each do |u|
      Tracker.people.set(u.id.to_s, u.json_for_mixpanel)
      Tracker.track(u.id.to_s, 'Signed Up')
      Tracker.track(u.id.to_s, 'Confirmed Registration')
      Tracker.track(u.id.to_s, 'Signed In')
      progressbar.increment
    end
  end
end
