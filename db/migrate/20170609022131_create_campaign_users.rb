class CreateCampaignUsers < ActiveRecord::Migration
  def change
    create_table :campaign_users do |t|
      t.string :email

      t.timestamps null: false
    end
  end
end
