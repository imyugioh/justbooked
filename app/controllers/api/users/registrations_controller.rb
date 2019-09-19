module Api
  class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :js
    # layout false, only: :create
  end
end
