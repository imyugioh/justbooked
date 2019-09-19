class AddHiddenFeildsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :hidden_for_sender, :boolean, default: false
    add_column :requests, :hidden_for_recipient, :boolean, default: false
    add_column :requests, :status, :integer, default: 0
  end
end
