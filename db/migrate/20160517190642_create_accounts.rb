class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :stripe_account
      t.string :stripe_secret
      t.string :stripe_publishable
      t.boolean :stripe_validated, default: false

      t.timestamps null: false
    end

    # User.all.each do |user|
    #   Account.create(user: user) if user.venues.any?
    #   Stripe::Customer.create(id: user.id, email: user.email)
    # end
  end

  def self.down
    drop_table :accounts
  end
end
