generateSlug = (_id, value, field) ->
  slug = slugify(value)
  selector = {_id: {$ne: _id}}
  selector[field] = slug
  i = 1
  slug = selector[field] = slugify(value) + "-" + i++  while Buildings.findOne(selector)
  slug

Buildings.before.insert (userId, building) ->
  building.slug = generateSlug(building._id, building.title, "slug")
  building.neighborhoodSlug = slugify(building.neighborhood)

  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if newVal = modifier.$set.title
    modifier.$set.slug = generateSlug(building._id, newVal, "slug")
  if newVal = modifier.$set.neighborhood
    modifier.$set.neighborhoodSlug = slugify(newVal)

  true
