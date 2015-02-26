generateSlug = (value, field) ->
  slug = slugify(value)
  selector = {}
  selector[field] = slug
  i = 1
  slug = selector[field] = slugify(value) + "-" + i++  while Buildings.findOne(selector)
  slug

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
    slug: generateSlug(building.name, "slug")
    neighborhoodSlug: generateSlug(building.neighborhood, "neighborhoodSlug")

  buildingPreSave(building)
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if newVal = modifier.$set.name
    modifier.$set.slug = generateSlug(newVal, "slug")
  if newVal = modifier.$set.neighborhood
    modifier.$set.neighborhoodSlug = generateSlug(newVal, "neighborhoodSlug")

  modifier.$set = modifier.$set or {}
  buildingPreSave(modifier.$set)
  true
