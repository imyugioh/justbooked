class CartItemsController < ApplicationController
	before_action :set_cart, only: [:create, :destroy]

	def create
		@cart.add_menu(params)
		if @cart.save
			render status: :ok, json: {message: "Successfully added."}.to_json
		else
			render status: :unprocessable_entity, json: {message: "Failed."}.to_json
		end
	end

	def destroy
		@cart_item.destroy
		if @cart_item.destroyed?
			render status: :ok, json: {message: "Successfully removed."}.to_json
		else
			render status: :unprocessable_entity, json: {message: "Failed."}.to_json
		end
	end

	private


	def set_cart_item
		@cart_item = CartItem.find(params[:id])
	end

	def cart_item_params
		params.required(:cart_item).permit(:product_id, :cart_id, :quantity)
	end
end
