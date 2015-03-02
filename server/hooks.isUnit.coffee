generateAgroIsUnit = (building) ->
  isUnit = !!building.isUnit
  if building.parentId
    isUnit = true
  else
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
    if @previous.parentId
      previousParent = Buildings.findOne(@previous.parentId)
      if previousParent
        generateAgroIsUnit(previousParent)
  generateAgroIsUnit(building)
