Meteor.methods
  "insertBuilding": (cityId) ->
    throw new Meteor.Error("wrong city " + cityId)  unless cityId in cityIds
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    buildingId = Buildings.insert({cityId: cityId})
    building = Buildings.findOne(buildingId)
    throw new Meteor.Error("building is not created")  unless building
    building = share.Transformations.Building(building)
    buildingId: buildingId
    url: Router.routes["building"].path(building.getRouteData())

  "addUnit": (parentId) ->
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    parent = Buildings.findOne(parentId)
    throw new Meteor.Error("no parent with id " + parentId)  unless parent
    throw new Meteor.Error("building can not be parent " + parentId)  if parent.parentId
    buildingId = Buildings.insert
      parentId: parentId
      cityId: parent.cityId
      neighborhood: parent.neighborhood
    building = Buildings.findOne(buildingId)
    throw new Meteor.Error("building is not created")  unless building
    building = share.Transformations.Building(building)
    buildingId: buildingId
    url: Router.routes["building"].path(building.getRouteData())

  "updateBuilding": (buildingId, data) ->
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    Buildings.update(buildingId, {$set: data})
    building = Buildings.findOne(buildingId)
    throw new Meteor.Error("no object with such id")  unless building
    building = share.Transformations.Building(building)
    Router.routes["building"].path(building.getRouteData())

  "imagesOrder": (buildingId, order) ->
    throw new Meteor.Error("no permissions")  unless Security.canOperateWithBuilding()
    building = Buildings.findOne(buildingId)
    order = _.uniq(order)
    if building and building.images.length is order.length
      invalid = false

      imagesOrdered = []
      for imageId in order
        image = _.find building.images, (item) ->
          item._id is imageId

        unless image
          invalid = true
          break
        else
          imagesOrdered.push(image)

      unless invalid
        Buildings.direct.update({_id: buildingId}, {$set: {images: imagesOrdered}})

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

  "importProperties": (data) ->
    errors = []
    errors.push({message: "error", reason: "no permissions", 0}) unless Security.canOperateWithBuilding()
    for property in data
      try
        Buildings.insert(property)
      catch error
        errors.push({message:"error", reason: "could not insert", id: property.source.mlsNo})
    if errors then errors else true
