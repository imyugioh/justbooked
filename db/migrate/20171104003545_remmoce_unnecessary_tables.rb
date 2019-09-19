class RemmoceUnnecessaryTables < ActiveRecord::Migration
  def change
  	execute "drop table packages, bookings CASCADE"
  end
end
