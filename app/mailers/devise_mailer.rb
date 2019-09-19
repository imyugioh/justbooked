class DeviseMailer < Devise::Mailer
  layout 'mailer'
  default from: "#{ENV['APPNAME']} <no-reply@#{ENV['APP_SHORT_NAME']}.com>"
end
