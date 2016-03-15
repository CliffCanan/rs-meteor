Buildings.before.insert (userId, building) ->
  _.defaults building,
    title: ""
    neighborhood: ""
    cityId: cityIds[0]
    btype: btypesIds[1]
    isOnMap: true
    isPublished: false
    propertyType: 0
    position: 0
    features: []
    images: []

  now = new Date()
  _.extend building,
    createdAt: now
    updatedAt: now

  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = new Date()
