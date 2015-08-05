Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  if building.isImportCompleted? and building.isImportCompleted is false
    if modifier.$addToSet? and modifier.$addToSet.images
      if ++building.images.length >= building.totalImportedImages
        modifier.$set.isImportCompleted = true