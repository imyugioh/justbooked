class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    User.all.each(&:regenerate_token)
  end
end
