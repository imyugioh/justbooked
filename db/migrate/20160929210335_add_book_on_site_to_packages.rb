class AddBookOnSiteToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :book_on_site, :boolean, default: true
  end
end
