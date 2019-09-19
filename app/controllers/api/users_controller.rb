module Api
  class UsersController < ApiController
    before_action :check_current_user!, only: [:update, :update_password]
    respond_to :json

    def cards
      render json: current_user.cards, root: :cards
    end

    def create
      user = User.new(user_params)
      redeem = params[:venue_token].present? && !params[:venue_token].empty?
      skip_confirmation(user) if redeem

      return render json: {
        users: [ "All fields are required" ]
      }, status: 400 if password_confirmation_fail && redeem

      if user.save
        redeem_and_notify(params[:venue_token], user) if redeem_venue
        render json: user
      else
        render json: user.errors.full_messages, status: 400
      end
    end

    def skip_confirmation(user)
      user.skip_confirmation_notification!
      user.skip_confirmation!
    end

    def redeem_and_notify(token, user)
      redeem_venue(token, user.id)
      sign_in user
      UserMailer.after_confirmation(user).deliver
    end

    def user_info
      render json: current_user, root: :user
    end

    def update_password
      user = current_user
      old_pass = params[:user][:old_password]
      new_pass = params[:user][:new_password]
      confirm_pass = params[:user][:new_password_confirm]

      if user.valid_password?(old_pass)
        user.password = new_pass
        user.password_confirmation = confirm_pass
        if user.save
          sign_in(user, bypass: true)
          render json: 'Password updated', status: 200
        else
          render json: user.errors.full_messages, status: 400
        end
      else
        render json: { users: ['Current password is wrong.']}, status: 400
      end
    end

    def update
      user = current_user
      if user.update_without_password(user_params)
        render json: user
      else
        render json: user.errors.full_messages, status: 400
      end
    end

    private

    def password_confirmation_fail
      params[:user][:password_confirmation].present?
      params[:user][:password_confirmation].blank?
    end

    def redeem_venue(token, user_id)
      Venue.redeem_venue(params[:venue_token], user_id)
    end

    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :newsletter,
        :email, :password, :password_confirmation
      )
    end
  end
end
