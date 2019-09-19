class InvitationMailer < ApplicationMailer
    add_template_helper(ApplicationHelper)
  
    # check out Google Doc for mail templates and content
    # https://docs.google.com/document/d/1CPszysXnpt_gOzUU5rnswnYMke_RTEycmfWk1jP5LVc/edit
    def chef_contact_invitation(chef_id, email, message)
      logger.info "Things are happening."
      logger.debug "Here's some info"
      @chef = Chef.find(chef_id)
      @message = message
      
      if ENV['ASSET_HOST'].present?
        @menu_link = "#{ENV['ASSET_HOST']}#{@chef.my_listings_path}"
      else
        raise "ENV['ASSET_HOST'] not configured"
      end
      mail(to: email, subject: 'Chef invitation mail')
    end
  
  end
  