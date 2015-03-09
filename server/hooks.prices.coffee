generateBuildingPrices = (building) ->
  prices = []
  pricesAgroMinMaxValues = {}
  for type in btypesIds
    root = type.charAt(0).toUpperCase() + type.slice(1)
    for postfix in ["From", "To"]
      fieldName = "price" + root + postfix
      fieldNameAgro = "agroPrice" + root + postfix
      value = building[fieldName]
      pricesAgroMinMaxValues[fieldNameAgro] = []
      if value
        prices.push(value)
        pricesAgroMinMaxValues[fieldNameAgro].push(value)
  Buildings.find({parentId: building._id, isPublished: true}).forEach (unit) ->
    if unit.btype
      for postfix in ["From", "To"]
        value = unit["price" + postfix]
        if value
          root = unit.btype.charAt(0).toUpperCase() + unit.btype.slice(1)
          fieldNameAgro = "agroPrice" + root + postfix
          prices.push(value)
          pricesAgroMinMaxValues[fieldNameAgro].push(value)

  if prices.length
    modifier =
      $set:
        agroPriceTotalFrom: Math.min.apply(null, prices)
        agroPriceTotalTo: Math.max.apply(null, prices)
      $unset: {}
  else
    modifier =
      $set: {}
      $unset:
        agroPriceTotalFrom: 1
        agroPriceTotalTo: 1

  for type in btypesIds
    root = type.charAt(0).toUpperCase() + type.slice(1)
    for postfix in ["From", "To"]
      fieldNameAgro = "agroPrice" + root + postfix
      if pricesAgroMinMaxValues[fieldNameAgro].length
        if postfix is "From"
          modifier.$set[fieldNameAgro] = Math.min.apply(null, pricesAgroMinMaxValues[fieldNameAgro])
        else
          modifier.$set[fieldNameAgro] = Math.max.apply(null, pricesAgroMinMaxValues[fieldNameAgro])
      else
        modifier.$unset[fieldNameAgro] = true
  unless Object.keys(modifier.$set).length
    delete modifier.$set
  unless Object.keys(modifier.$unset).length
    delete modifier.$unset

  Buildings.direct.update({_id: building._id}, modifier)

Buildings.after.insert (userId, building) ->
  if building.parentId and building.isPublished
    parent = Buildings.findOne(building.parentId)
    if parent
      generateBuildingPrices(parent)
  generateBuildingPrices(building)

Buildings.after.update (userId, building, fieldNames, modifier, options) ->
  if @previous.parentId isnt building.parentId
    oldParent = Buildings.findOne(@previous.parentId)
    if oldParent
      generateBuildingPrices(oldParent)
    newParent = Buildings.findOne(building.parentId)
    if newParent
      generateBuildingPrices(newParent)
  else if @previous.isPublished isnt building.isPublished
    if building.parentId
      parent = Buildings.findOne(building.parentId)
      if parent
        generateBuildingPrices(parent)

  generateBuildingPrices(building)
