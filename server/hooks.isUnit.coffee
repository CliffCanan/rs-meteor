generateAgroIsUnit = (building) ->
  isUnit = true
  unless building.parentId
    for type in btypesIds
      fieldName = "price" + type.charAt(0).toUpperCase() + type.slice(1)
      if building[fieldName + "From"]
        isUnit = false
        break
    if isUnit
      if Buildings.find({parentId: building._id}).count()
        isUnit = false
  Buildings.direct.update({_id: building._id}, {$set: {agroIsUnit: isUnit}})

Buildings.before.insert (userId, building) ->
  if building.parentId
    building.agroIsUnit = true

Buildings.after.insert (userId, building) ->
  if building.parentId
    Buildings.direct.update({_id: building.parentId}, {$set: {agroIsUnit: false}})

Buildings.after.update (userId, building, fieldNames, modifier, options) ->
  if @previous.parentId isnt building.parentId
    previousParent = Buildings.findOne(@previous.parentId)
    if previousParent
      generateAgroIsUnit(previousParent)
    Buildings.direct.update({_id: building.parentId}, {$set: {agroIsUnit: false}})
  generateAgroIsUnit(building)
