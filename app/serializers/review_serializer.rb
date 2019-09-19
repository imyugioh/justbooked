class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :chef_id, :menu_id, :rate, :feedback
end
