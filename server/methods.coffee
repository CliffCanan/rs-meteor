Meteor.methods
  "insertBuilding": ->
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    buildingId = Buildings.insert({})
    building = Buildings.findOne(buildingId)
    unless building
      throw new Meteor.Error("building is not created")
    building = share.Transformations.Building(building)
    Router.routes["building"].path(building.getRouteData())

  "updateBuilding": (buildingId, data) ->
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    Buildings.update(buildingId, {$set: data})
    building = Buildings.findOne(buildingId)
    unless building
      throw new Meteor.Error("no object with such id")
    building = share.Transformations.Building(building)
    Router.routes["building"].path(building.getRouteData())

  "getParentBuildingsChoices": (buildingId) ->
    choices = []
    selector = {_id: {$ne: buildingId}, parentId: {$exists: false}}
    Buildings.find(selector, {sort: {title: 1}, fields: {title: 1}}).forEach (building) ->
      choices.push
        id: building._id
        text: building.title
    choices

  "getAdminSameChoices": (buildingId) ->
    fields =
      adminAvailability: 1
      adminEscorted: 1
      adminAppFee: 1
      adminOfficeHours: 1
      adminScheduling: 1
      adminContact: 1
      adminNotes: 1
    choices = []
    selector = {_id: {$ne: buildingId}, agroCanBeSame: true, parentId: {$exists: false}}
    Buildings.find(selector, {sort: {title: 1}, fields: _.extend({title: 1}, fields)}).forEach (building) ->
      choice =
        id: building._id
        text: building.title
      for key, value of fields
        choice[key] = building[key]
      choices.push(choice)
    choices

