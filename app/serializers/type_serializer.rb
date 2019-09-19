class TypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :text

  def text
    name
  end
end
