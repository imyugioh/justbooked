module Api
  class Users::SessionsController < Devise::SessionsController
    respond_to :js
    layout false, only: :create
    skip_before_filter :publish_session

    def new
      super
    end

    def create
      self.resource = warden.authenticate(auth_options)

      if resource.nil? || resource.active_for_authentication? == false
        redirect_to new_user_session_path
      else
        success = sign_in(resource_name, resource)
        puts "logged in ? #{success}"
        @redirect_location = after_sign_in_path_for(resource)
        respond_to do |format|
          format.html { redirect_to(@redirect_location) }
          format.js
        end
      end
    end
  end
end
