module Api
  class ReviewsController < ApiController
    before_action :check_current_user!, only: [:create]
    respond_to :json

    def index
      venue = Venue.friendly.find(params[:venue_id])
      reviews = venue.comments.order('published_at desc')
      render json: reviews, current_user_id: current_user ? current_user.id : 0
    end

    def create
      venue = Venue.friendly.find(params[:venue_id])
      review = venue.comments.new(review_params)
      review.user = current_user
      review.published_at = Time.zone.now
      Tracker.track(current_user.id.to_s, 'Added a review to venue', {
        venue_id: venue.id,
        venue_slug: venue.slug
      })

      if review.save
        # publish_event(request, comment)
        render json: review, current_user_id: current_user.id, root: 'review'
      else
        render json: review.errors.full_messages, status: 400
      end
    end

    # def update
      # venue = Venue.friendly.find(params[:id])
      # venue.venue_type_list = params[:venue][:venue_types]
      # venue.event_type_list = params[:venue][:event_types]
      # venue.amenity_list = params[:venue][:amenities]
      # venue.social_links = params[:venue][:social_links]

      # if venue.update_attributes(venue_params)
      #   venue.assign_assets(params[:token])
      #   render json: venue
      # else
      #   render json: venue.errors.full_messages, status: 400
      # end
    # end

    private

    def publish_event(request, comment)
      json = comment.as_json
      json[:commenter] = current_user.full_name
      json[:event_type] = 'Comment'
      ::Live.publish_async("request_#{request.id}", json)
    end

    def review_params
      params.require(:review).permit(:comment)
    end
  end
end
