desc 'This task is called by the Heroku scheduler add-on'
task new_comment_notifications: :environment do
  p 'Sending new comment notifications'
  bookings = Booking.not_sent_emails.not_read_by_either_party
  bookings.each do |booking|
    next unless booking.comments.any?
    u = booking.read_by_recipient ? booking.sender : booking.recipient
    action = booking.read_by_recipient ? 'sent' : 'received'
    UserMailer.delay(
      queue: 'notifications').new_comment_notification(booking, u, action)
  end
  bookings.update_all(email_sent:  true, email_sent_at: Time.zone.now)
  p 'Done sending new comment notifications'
end

desc 'This task is called by the Heroku scheduler add-on'
task capture_charges: :environment do
  p 'Capturing charges'
  charges = Charge.where('charge_at = ? AND captured = ? AND charge_attempts < ?', Date.today, false, 4 )
  charges.each(&:capture)
  p 'Done'
end

desc 'This task is called by the Heroku scheduler add-on'
task update_packages: :environment do
  p 'Updating packages'
  packages = Package.available.where('date_end < ?', Date.today)
  packages.update_all(expired: true)
  Package.transaction do
    packages.each(&:save!)
  end
  p 'Done'
end
