class Cart < ActiveRecord::Base
	belongs_to :user
	has_many :cart_items

	def add_menu(menu_params)
		current_item = cart_items.find_by(menu_id: menu_params[:menu][:menu_id])

		if current_item
			current_item.quantity += menu_params[:menu][:quantity].to_i
			current_item.save
		else
			new_item = cart_items.create(menu_id: menu_params[:menu][:menu_id],
				quantity: menu_params[:menu][:quantity],
				cart_id: self.id)
		end
		new_item
	end
end
