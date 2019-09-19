class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commenter, :comment, :published_at

  def commenter
    object.user_id == serialization_options[:current_user_id]  ? 'You' : object.user.full_name
  end
end
