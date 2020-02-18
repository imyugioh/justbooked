class ReviewsController < InheritedResources::Base

  def index
  end

  def save_review
    puts '>>>>>>>>>>>>>>>>>save_review'
    puts params[:purchase_id]
    @infor = Purchase.find_by(:token => params[:purchase_id])
		review = Review.new(:purchase_id => @infor.id, :menu_id => params[:menu_id], :rating => params[:rate_marks], :feedback => params[:feedback],
						:user_id => @infor.user_id, :chef_id => @infor.chef_id, :first_name => @infor.first_name, :last_name => @infor.last_name)
		review.save

		puts params[:feedback]
		@feedback = Review.find_by(:menu_id => params[:menu_id], :purchase_id => @infor.id)
		OrderMailer.send_review_chef(@feedback).deliver
  end

  def show
		if @infor = Purchase.find_by(:token => params[:id])
			if @infor.request_status != 'Accepted'
				redirect_to root_path
			end

			@menus ||= []
			@infor.menus.each do |item|
				menu_record = item.menu
				review = Review.find_by(:purchase_id => @infor.id, :menu_id => menu_record.id)
				if review.blank?
					@menus.push(menu_record)
				end
			end
		end

		if @menus.size == 0
			redirect_to root_path
		end
  end
end

