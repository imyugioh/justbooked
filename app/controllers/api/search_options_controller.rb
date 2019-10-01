module Api
  class SearchOptionsController < ApiController
    include ApplicationHelper
    # before_action :check_current_user!
    respond_to :json

    def article_tags
      article_tags = Tag.where(tag_type: nil).where('name ILIKE ?', "%#{params[:q]}%").order(:name)
      render json: article_tags, root: 'tags', each_serializer: TypeSerializer
    end

    # Get the cuisine_types from ApplicationHelper
    def all_cuisine_types
      render json: cuisine_types, root: 'cuisine_types', each_serializer: TypeSerializer
    end

    # Get the dietary_types from ApplicationHelper
    def dietary_types
      render json: dietary_types, root: 'dietary_types', each_serializer: TypeSerializer
    end


    def food_items
      food_items = Tag.joins(:taggings).where(
        'taggings.context = ?', params[:food_type]
      ).where('tags.name ILIKE ?', "%#{params[:search]}%").uniq.order('name asc')
      # food_items = Tag.where('name ILIKE ?', "%#{params[:search]}%") unless food_items.any?
      render json: food_items, root: 'items', each_serializer: TypeSerializer
    end
  end
end
