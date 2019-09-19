class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  # default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  validates :comment, presence: true

  after_create :track_event

  def track_event
    Tracker.track(user_id.to_s, "Commented to #{commentable_type.downcase}", { request_id: commentable.id })
  end
end
