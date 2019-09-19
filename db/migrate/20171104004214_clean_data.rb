class CleanData < ActiveRecord::Migration
  def change
  	execute "truncate table accounts"
  	execute "truncate table inquiry_items"
  	execute "truncate table cards"
  	execute "truncate table used_coupons"
  	execute "delete from users where email !=' admin@justbooked.com'"
  end
end







