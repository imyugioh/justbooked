class RemoveDailySchedules < ActiveRecord::Migration
  def change
    remove_column :chefs, :sun_start
    remove_column :chefs, :sun_end

    remove_column :chefs, :mon_start
    remove_column :chefs, :mon_end

    remove_column :chefs, :tue_start
    remove_column :chefs, :tue_end

    remove_column :chefs, :wed_start
    remove_column :chefs, :wed_end

    remove_column :chefs, :thu_start
    remove_column :chefs, :thu_end

    remove_column :chefs, :fri_start
    remove_column :chefs, :fri_end

    remove_column :chefs, :sat_start
    remove_column :chefs, :sat_end

    remove_column :chefs, :min_order_amount

  end
end
