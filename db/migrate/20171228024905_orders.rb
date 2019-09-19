class Orders < ActiveRecord::Migration
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phonenumber, :string
    add_column :orders, :deliver_date, :date
    add_column :orders, :deliver_time, :string, default: 'ASAP'
    add_column :orders, :promo_code, :string
    change_column_default(
        :orders,
        :currency,
        'CAD'
    )
    rename_column :orders, :description, :more_detail
    rename_column :orders, :address_id, :delivery_address_id
  end
end
