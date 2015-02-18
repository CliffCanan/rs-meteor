Buildings.before.insert (userId, building) ->
  _.extend building,
    slug: slugify(building.name)
    neighborhoodSlug: slugify(building.neighborhood)

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if modifier.$set.name
    modifier.$set.slug = slugify(building.name)
  if modifier.$set.neighborhood
    modifier.$set.neighborhoodSlug = slugify(building.neighborhood)
