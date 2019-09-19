class AddSessionIdToCart < ActiveRecord::Migration
  def change
    add_column :carts, :session_id, :string
  end
end
