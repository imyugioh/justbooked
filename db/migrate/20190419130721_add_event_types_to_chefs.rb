class AddEventTypesToChefs < ActiveRecord::Migration
  def change
    add_column :chefs, :event_types, :string
  end
end
