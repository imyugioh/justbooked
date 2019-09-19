class AddMaxNumberServing < ActiveRecord::Migration
  def change
    add_column :menus, :max_number_serving, :integer
    add_column :menus, :auto_accept, :bool, default: false
  end
end
