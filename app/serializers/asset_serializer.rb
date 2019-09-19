class AssetSerializer < ActiveModel::Serializer
  attributes :id, :token, :delete_url, :original_url, :chef_profile_url,
             :chef_banner_url, :menu_thumb_url, :menu_medium_url, :menu_large_url


  def original_url
    object.image.url
  end

  def chef_profile_url
    object.image.url(:chef_profile)
  end

  def chef_banner_url
    object.image.url(:chef_banner)
  end

  def menu_thumb_url
    object.image.url(:menu_thumb)
  end

  def menu_medium_url
    object.image.url(:menu_medium)
  end

  def menu_large_url
    object.image.url(:menu_large)
  end

end
