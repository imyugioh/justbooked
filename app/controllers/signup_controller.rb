class SignupController < ApplicationController
  layout false

  def index
    @show_form = true
  end


  def create
    if params[:email].present?
      @show_form = false
      CampaignUser.create(email: params[:email])
    end
    render :thank_you
  end


end
