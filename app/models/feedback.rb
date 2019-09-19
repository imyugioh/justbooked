class Feedback < ActiveRecord::Base
  validates :email, :first_name, :last_name, :message, presence: true
  validates_format_of :email, with: Devise::email_regexp
end
