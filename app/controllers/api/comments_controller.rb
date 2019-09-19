module Api
  class CommentsController < ApiController
    before_action :check_current_user! #, only: [:create, :update, :favorites_toggle]
    respond_to :json

    def create
      request = Request.all_alive_requests_for(current_user).where(id: params[:request_id]).first
      return render json: {message: 'not found'}, status: 404 unless request.present?
      comment = request.comments.new(comment_params)
      comment.user = current_user
      participant_id = (request.sender_id == current_user.id) ? request.recipient_id : request.sender_id
      participant = User.where(id: participant_id).first
      request.update_read(participant, false) if participant.present?

      if comment.save
        publish_event(request, comment)
        render json: comment, current_user_id: current_user.id
      else
        render json: comment.errors.full_messages, status: 400
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

    def comment_params
      params.require(:comment).permit(:comment)
    end
  end
end
