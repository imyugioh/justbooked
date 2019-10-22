class PurchaseController < ApplicationController
  def charge
  	puts '>>>>>>>>>>>>>>>>>>>>>>>>>>purchase_charge'
  	puts params[:id]
  	puts params[:request_status]

    @purchase = Purchase.find_by_id(params[:id])
  	if @purchase.request_status == 'New'
  		@purchase.request_status = params[:request_status]
  		if params[:request_status] == 'Accepted'
        result = @purchase.capture
      elsif params[:request_status] == 'Declined'
        OrderMailer.decline_order(@purchase, @purchase.chef).deliver
  		end
  	end
  	@purchase.save
    render :json => {message: 'success'}, :status => :ok
  end

  def charge_back
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>purchase charge_back'
    puts params[:id]
    puts params[:request_status]

    @purchase = Purchase.find_by_id(params[:id])
    if @purchase.request_status == 'New'
      @purchase.request_status = params[:request_status]
      if params[:request_status] == 'Decline'
        @purchase.charge_back
      end
    end
    @purchase.save
    redirect_to order_index_path

  end
end
