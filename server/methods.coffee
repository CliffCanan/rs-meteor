# fs = Meteor.npmRequire("fs")
ab = Meteor.npmRequire("base64-arraybuffer")

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

    console.log "====== importProperties ======"
    console.log "importProperties > data: ", data

    errors = []
    errors.push({message: "error", reason: "no permissions", 0}) unless Security.canOperateWithBuilding()
    for property in data
      try
        Buildings.insert(property)
      catch error
        errors.push({message:"error", reason: "could not insert", id: property.source.mlsNo})
    if errors then errors else true

  "importImage": (buildingId, base64image) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canOperateWithBuilding()

    console.log "====== importImage ======"
    console.log "importImage > buildingId: " + buildingId
    # console.log "importImage > base64image: ", base64image
     
    matches = base64image.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/)
    if matches.length isnt 3
      return {message: "error", reason: "not a base64 image", 0}
    type = matches[1]
    imageBuffer = new Buffer(matches[2], "base64").toString("base64");

    arrayBuffer = ab.decode(imageBuffer)

    ticks = new Date().getTime()
    fileName = buildingId + "_" + ticks;
    
    file = new FS.File();
    file.attachData arrayBuffer, {type: type}, (error) ->
      return {message: "error", reason: "could not create image from buffer", 0}
    file.name(fileName)
    BuildingImages.insert(file)
    console.log "image file: ", file
    Buildings.update(_id: buildingId, {$addToSet: {images: file}})
    return true

  "createClient": (clientName) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    [firstName, lastName] = clientName.split ' '
    fields =
      name: clientName
      firstName: firstName
      lastName: lastName
    clientId = ClientRecommendations.insert(fields)
    clientId: clientId
    url: Router.routes["clientRecommendations"].path(clientId: clientId)

  "recommendBuilding": (clientId, buildingId) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    ClientRecommendations.update(clientId, {$addToSet: {buildingIds: buildingId}})

  "unrecommendBuilding": (clientId, buildingId) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    ClientRecommendations.update(clientId, {$pull: {buildingIds: buildingId}})

  "recommendUnit": (clientId, parentId, unitId) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    unitObject = {parentId: parentId, unitId: unitId}
    ClientRecommendations.update(clientId, {$pull: {'unitIds': {parentId: parentId}}})
    ClientRecommendations.update(clientId, {$addToSet: {unitIds: unitObject}})

