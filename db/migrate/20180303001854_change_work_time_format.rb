class ChangeWorkTimeFormat < ActiveRecord::Migration
  def up
    Chef.all.each do |chef|
      chef.update_columns(
        sun_start: chef.sun_start.to_i,
        sun_end: chef.sun_end.to_i,
        mon_start: chef.mon_start.to_i,
        mon_end: chef.mon_end.to_i,

        tue_start: chef.tue_start.to_i,
        tue_end: chef.tue_end.to_i,
        wed_start: chef.wed_start.to_i,
        wed_end: chef.wed_end.to_i,
        thu_start: chef.thu_start.to_i,
        thu_end: chef.thu_end.to_i,
        fri_start: chef.fri_start.to_i,
        fri_end: chef.fri_end.to_i,
        sat_start: chef.sat_start.to_i,
        sat_end: chef.sat_end.to_i
      )
    end

    change_column :chefs, :sun_start, 'integer USING CAST(sun_start AS integer)'
    change_column :chefs, :sun_end, 'integer USING CAST(sun_end AS integer)'

    change_column :chefs, :mon_start, 'integer USING CAST(mon_start AS integer)'
    change_column :chefs, :mon_end, 'integer USING CAST(mon_end AS integer)'

    change_column :chefs, :tue_start, 'integer USING CAST(tue_start AS integer)'
    change_column :chefs, :tue_end, 'integer USING CAST(tue_end AS integer)'

    change_column :chefs, :wed_start, 'integer USING CAST(wed_start AS integer)'
    change_column :chefs, :wed_end, 'integer USING CAST(wed_end AS integer)'

    change_column :chefs, :thu_start, 'integer USING CAST(thu_start AS integer)'
    change_column :chefs, :thu_end, 'integer USING CAST(thu_end AS integer)'

    change_column :chefs, :fri_start, 'integer USING CAST(fri_start AS integer)'
    change_column :chefs, :fri_end, 'integer USING CAST(fri_end AS integer)'

    change_column :chefs, :sat_start, 'integer USING CAST(sat_start AS integer)'
    change_column :chefs, :sat_end, 'integer USING CAST(sat_end AS integer)'
  end

  def down
    puts ">>>> can't revert. skipped"
  end

end
