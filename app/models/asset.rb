class Asset < ActiveRecord::Base
  belongs_to :assetable, polymorphic: true
  validates :image_file_name, presence: true
  attr_accessor :asset_type
  has_attached_file :image, styles: {
    chef_profile: '135',
    chef_banner: '1369x342#',
    menu_thumb: '200x100#',
    menu_medium: '400x200#',
    menu_large: '800x400#'
  }, default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage/
  validates_attachment_size :image, :less_than => 5.megabytes, :unless => Proc.new {|m| m[:image].nil?}


  def self.default_chef_profile
    find_by(assetable_id: nil, assetable_type: :Chef, asset_detail: :default_chef_profile)
  end

  def self.default_chef_header
    find_by(assetable_id: nil, assetable_type: :Chef, asset_detail: :default_chef_header)
  end

  def delete_url
    "/api/assets/#{id}?token=#{token}"
  end


  def test
    assetable_type
  end

end
