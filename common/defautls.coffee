buildingPreSave = (modifier) ->
  prices = []
  for type in btypesIds
    obj = modifier[type]
    if obj
      if obj.from
        prices.push(obj.from)
      if obj.to
        prices.push(obj.to)
  if prices.length
    modifier.priceMin = Math.min.apply(null, prices)
    modifier.priceMax = Math.max.apply(null, prices)

Buildings.before.insert (userId, building) ->
  _.extend building,
    slug: slugify(building.name)
    neighborhoodSlug: slugify(building.neighborhood)

  buildingPreSave(building)
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if modifier.$set.name
    modifier.$set.slug = slugify(building.name)
  if modifier.$set.neighborhood
    modifier.$set.neighborhoodSlug = slugify(building.neighborhood)

  modifier.$set = modifier.$set or {}
  buildingPreSave(modifier.$set)
  true
