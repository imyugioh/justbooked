Paperclip.interpolates :assetable_type do |attachment, style|
  attachment.instance.assetable_type.downcase
end

Paperclip.interpolates :documentable_type do |attachment, style|
  attachment.instance.documentable_type.downcase
end


