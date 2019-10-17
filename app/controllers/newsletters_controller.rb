class NewslettersController < ApplicationController

  # GET /newsletters/new
  def new
    @newsletter = Newsletter.new
  end


  # POST /newsletters
  # POST /newsletters.json
  def create
    success = false
    existing_newsletter = Newsletter.find_by(email: newsletter_params[:email])
    if existing_newsletter.nil?
      @newsletter = Newsletter.new(newsletter_params)
      if @newsletter.save
        success = true
      end
    else
      success = true
    end

    if success
      render json: {},  status: :created
    else
      render json: @newsletter.errors, status: :unprocessable_entity
    end
  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def newsletter_params
    params.require(:newsletter).permit(:city, :email)
  end
end
