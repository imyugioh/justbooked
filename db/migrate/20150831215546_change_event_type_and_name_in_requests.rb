class ChangeEventTypeAndNameInRequests < ActiveRecord::Migration
  def change
    rename_column :requests, :event_type_id, :event_type
    change_column :requests, :event_type, :string
  end
end
