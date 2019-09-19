class AddEmailSentToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :email_sent, :boolean, default: false
    add_column :requests, :email_sent_at, :time
  end
end
