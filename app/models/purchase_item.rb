class PurchaseItem < ActiveRecord::Base
  belongs_to :purchase
  validates :model_type, inclusion: { in: %w(Menu MenuItem Addon), message: "%{value} is not a valid model_type" }

  def menu_items
    if model_type == 'Menu'
      PurchaseItem.where(parent_id: id, model_type: 'MenuItem', purchase_id: purchase_id)
    end
  end

  def addons
    if model_type == 'Menu'
      PurchaseItem.where(parent_id: id, model_type: 'Addon', purchase_id: purchase_id)
    end
  end

  def menu
    if model_type === 'Menu'
      Menu.find(model_id)
    else model_type === 'MenuItem'
      Menu.find(parent_id)
    end
  end

  def menu_item
    if model_type == 'MenuItem'
      MenuItem.find(model_id)
    end
  end

  def addon
    if model_type === 'Addon'
      Addon.find(model_id)
    end
  end

  # def detail
  #   case model_type
  #   when 'Menu'
  #     menu
  #   when 'MenuItem'
  #     menu_item
  #   when 'Addon'
  #     addon
  #   end
  # end

end
