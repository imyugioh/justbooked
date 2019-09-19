class RenameTitleToNameInVenues < ActiveRecord::Migration
  def change
    change_table :venues do |t|
      t.rename :title, :name
    end
  end
end
