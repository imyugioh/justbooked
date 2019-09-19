class MenuItem < ActiveRecord::Base
  belongs_to :menu

  def display_price
    "$ #{price}"
  end
end
