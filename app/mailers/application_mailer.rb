class ApplicationMailer < ActionMailer::Base
  default from: "orders@justbooked.com"
  layout 'mailer'
end
