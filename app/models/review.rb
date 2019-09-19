class Review < ActiveRecord::Base
  belongs_to :menu
  belongs_to :user
  belongs_to :chef
  has_one :purchase

end
