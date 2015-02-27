generateSlug = (_id, value, field) ->
  slug = slugify(value)
  selector = {_id: {$ne: _id}}
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
    slug: generateSlug(building._id, building.title, "slug")
    neighborhoodSlug: slugify(building.neighborhood)

  buildingPreSave(building)
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if newVal = modifier.$set.title
    modifier.$set.slug = generateSlug(building._id, newVal, "slug")
  if newVal = modifier.$set.neighborhood
    modifier.$set.neighborhoodSlug = slugify(newVal)

  modifier.$set = modifier.$set or {}
  buildingPreSave(modifier.$set)
  true
