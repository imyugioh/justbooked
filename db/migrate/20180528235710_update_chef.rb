class UpdateChef < ActiveRecord::Migration
  def change
    Chef.all.each do |chef|
      chef.update_attribute('pre_order_min_order_amount', chef.min_order_amount)
    end
  end
end
