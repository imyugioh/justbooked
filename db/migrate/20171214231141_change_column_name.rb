class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :chefs, :thr_start, :thu_start
    rename_column :chefs, :thr_end, :thu_end
  end
end
