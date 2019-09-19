class AddReadColumnsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :read_by_sender, :boolean, default: false
    add_column :requests, :read_by_recipient, :boolean, default: false
  end
end
