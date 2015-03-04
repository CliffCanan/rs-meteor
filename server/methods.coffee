Meteor.methods
  "updateBuilding": (buildingId, data) ->
    Buildings.update(buildingId, {$set: data})
    building = Buildings.findOne(buildingId)
    unless building
      throw Meteor.Error("no object with such id")
    building.slug
