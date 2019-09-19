class Document < ActiveRecord::Base
  belongs_to :assetable, polymorphic: true
  validates :document_file_name, presence: true
  attr_accessor :document_type
  has_attached_file :document

	validates_attachment_content_type :document, :content_type => ['image/jpeg', 'image/png', 'application/pdf']
end
