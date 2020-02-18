json.type "FeatureCollection"
json.features do |features|
  json.array!(menus) do |menu|
    json.partial! 'listings/menu', menu: menu
  end
end
