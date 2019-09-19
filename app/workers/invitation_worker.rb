class InvitationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'invitation_mailer'

  def perform(chef_id, contacts, message)

    contacts.each do |email|
      mailer = InvitationMailer.chef_contact_invitation(chef_id, email, message)
      mailer.deliver_now
    end

  end
end
