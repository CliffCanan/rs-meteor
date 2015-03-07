Buildings.before.insert (userId, building) ->
  _.defaults building,
    title: "New Building Title"
    neighborhood: "center-city"
    cityId: cityIds[0]
    btype: btypesIds[1]
    isOnMap: false
    isPublished: false
    propertyType: 0

  now = new Date()
  _.extend building,
    createdAt: now
    updatedAt: now

  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = new Date()
