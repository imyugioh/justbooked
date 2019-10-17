class MessagesController < ApplicationController

  # GET /contacts/new
  def new
    @message = Message.new
  end


  # POST /contacts
  # POST /contacts.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        flash[:success] = 'Thank you for contacting us!'
        format.html { render :new, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end



  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:first_name, :last_name, :email, :message)
  end


end
