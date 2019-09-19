class AddSocialLinksToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :social_links, :json, default: {
      facebook: '', google: '', twitter: '', pinterest: '', linkedin: ''
    }
  end
end
