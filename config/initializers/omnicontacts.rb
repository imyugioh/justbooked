require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  if ENV['CLOUDSPONGE_ENV'] == 'local'
    importer :gmail, "76573547670-okp2e77spmuisn0e18v5q2q0nnm6b2j2.apps.googleusercontent.com", "rOb4Qy79EThKBzCESqzx1ij2", {:redirect_path => "/invites/gmail/contact_callback"}
    importer :yahoo, "consumer_id", "consumer_secret", {:callback_path => "/callback"}
    importer :facebook, "client_id", "client_secret"
  elsif ENV['CLOUDSPONGE_ENV'] == 'staging'
    importer :gmail, "76573547670-0l8np5f05pjp98sol0d1cg29l21iprrt.apps.googleusercontent.com", "QbbYNnlQe8ym9VBMp_aUD416", {:redirect_path => "/invites/gmail/contact_callback"}
    importer :yahoo, "consumer_id", "consumer_secret", {:callback_path => "/callback"}
    importer :facebook, "client_id", "client_secret"
  else
    importer :gmail, "76573547670-f41cbtve1s5mqjlfig61qpefso23v3ip.apps.googleusercontent.com", "73LJqVwWmUTDeX2UC4e9-kwh", {:redirect_path => "/invites/gmail/contact_callback"}
    importer :yahoo, "consumer_id", "consumer_secret", {:callback_path => "/callback"}
    importer :facebook, "client_id", "client_secret"
  end
end