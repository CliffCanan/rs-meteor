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

  "getSimilarProperties": (building) ->
    from = building.agroPriceTotalTo - 200
    to = building.agroPriceTotalTo + 200
    selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}
    buildings = Buildings.find(selector, {limit: 4}).fetch()

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
        id = Buildings.insert(property)
        console.log "Inserted new building with id #{id}"
      catch error
        errors.push({message:"error", reason: "could not insert", id: property.source.mlsNo})
    if errors then errors else true

  "importImage": (buildingId, uri) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canOperateWithBuilding()

    console.log "====== importImage ======"
    console.log "importImage > buildingId: " + buildingId
    # console.log "importImage > base64image: ", base64image
     
    BuildingImages.insert uri, (err, file) ->
      Buildings.update(_id: buildingId, {$addToSet: {images: file}})
      console.log "image file: ", file
    return true

  "importImagesByBatch": (uploadObject) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canOperateWithBuilding()

    console.log "====== importImagesByBatch ======"

    clientId = uploadObject.clientId

    for object in uploadObject.buildings
      buildingId = object.buildingId
      console.log "importImage > buildingId: " + buildingId
      if object.images
        for uri in object.images
          try
            file = BuildingImages.insert uri
            console.log "image file: ", file
            file = _.omit(file, 'collection')
            Buildings.update(_id: buildingId, {$addToSet: {images: file}})
          catch error
            console.error(error)
          Meteor.sleep(1500)
      # All images imported for this building. Mark it as complete and it will appear in the list.
      Buildings.update(buildingId, {$set: {isImportCompleted: true, isPublished: true}})

    ClientRecommendations.update(clientId, {$set: {importCompletedAt: new Date()}})
    return true

  "importToClientRecommendations": (clientName, buildingIds) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canOperateWithBuilding()

    console.log "====== importToClientRecommendations ======"
    console.log "clientName: #{clientName}"
    console.log "buildingIds: #{buildingIds}"

    if buildingIds.length
      currentUser = Meteor.users.findOne(this.userId)
      result = ClientRecommendations.upsert
        name: clientName,
        {
          $addToSet: {buildingIds: {$each: buildingIds}}
          $set: {
            userId: currentUser._id
            userName: currentUser.profile.name
            createdAt: new Date()
          }
        }
      return result
    else
      return false

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

  "recommendUnit": (clientId, unitId, parentId) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    unitObject = {parentId: parentId, unitId: unitId}
    ClientRecommendations.update(clientId, {$addToSet: {buildingIds: parentId}})
    ClientRecommendations.update(clientId, {$pull: {'unitIds': {parentId: parentId}}})
    ClientRecommendations.update(clientId, {$addToSet: {unitIds: unitObject}})

  "unrecommendUnit": (clientId, unitId) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    ClientRecommendations.update(clientId, {$pull: {'unitIds': {unitId: unitId}}})

  "deleteClientRecommendationAndBuildings": (clientId) ->
    clientRecommendation = ClientRecommendations.findOne(clientId);

    for id in clientRecommendation.buildingIds
      building = Buildings.findOne(id)
      if building
        for imageId in building.images
          BuildingImages.remove(imageId._id) if imageId?
        Buildings.remove(id)

    ClientRecommendations.remove(clientId)

  "getVimeoVideos": () ->
    Vimeo = Meteor.npmRequire('vimeo').Vimeo
    vimeo = new Vimeo(Meteor.settings.vimeo.clientId, Meteor.settings.vimeo.clientSecret, Meteor.settings.vimeo.accessToken)
    getVideoParams = 
      method: 'GET'
      path: '/me/videos'

    videos = []

    response = Async.runSync (done) ->
      vimeo.request getVideoParams, (error, body, status_code, headers) ->
        data = body.data

        data.forEach (item) ->
          thumbnail = _.where(item.pictures.sizes, {"width": 295})
          thumbnailLink = thumbnail[0].link

          video =
            vimeoId: item.uri.replace('/videos/', '')
            createdAt: new Date()
            uploadedAt: new Date(item.created_time)
            name: item.name,
            thumbnail: thumbnailLink,
            embed: item.embed.html
            duration: item.duration

          videos.push video

        done(null, videos)

    response.result.forEach (video) ->
      VimeoVideos.upsert({vimeoId: video.vimeoId}, {$set: video})

    response.result

  "insertReview": (reviewObject) ->
    reviewObject.createdAt = new Date()
    reviewObject.isPublished = false

    if reviewObject.isAnonymousReview
      reviewObject.isAnonymousReview = true 
      reviewObject.name = null
    else
      reviewObject.isAnonymousReview = false

    reviewItems = []
    reviewItemsObject = [
      {label: 'Noise', key: 'noise'}
      {label: 'Location', key: 'location'}
      {label: 'Amenities', key: 'amenities'}
      {label: 'Management', key: 'management'}
      {label: 'Value', key: 'value'}
      {label: 'Quality', key: 'quality'}
    ]

    for item in reviewItemsObject
      reviewItems.push
        label: item.label
        score: reviewObject[item.key]

      reviewObject = _.omit(reviewObject, item.key)

    reviewObject.reviewItems = reviewItems

    BuildingReviews.insert reviewObject

  "updateReview": (reviewObject) ->
    if reviewObject.isAnonymousReview
      reviewObject.isAnonymousReview = true 
      reviewObject.name = null
    else
      reviewObject.isAnonymousReview = false

    reviewItems = []
    reviewItemsObject = [
      {label: 'Noise', key: 'noise'}
      {label: 'Location', key: 'location'}
      {label: 'Amenities', key: 'amenities'}
      {label: 'Management', key: 'management'}
      {label: 'Value', key: 'value'}
      {label: 'Quality', key: 'quality'}
    ]

    for item in reviewItemsObject
      reviewItems.push
        label: item.label
        score: reviewObject[item.key]

      reviewObject = _.omit(reviewObject, item.key)

    reviewObject.reviewItems = reviewItems

    id = reviewObject.id
    reviewObject = _.omit(reviewObject, 'id')

    BuildingReviews.update id, {$set: reviewObject}

  "publishReview": (reviewId) ->
    modifier = {}
    modifier.$set =
      isPublished: true
      publishedAt: new Date()
      updatedByUserId: this.userId

    BuildingReviews.update reviewId, modifier

  "hideReview": (reviewId) ->
    modifier = {}
    modifier.$set =
      isPublished: false
      updatedByUserId: this.userId

    BuildingReviews.update reviewId, modifier

  "removeReview": (reviewId) ->
    modifier = {}
    modifier.$set =
      isPublished: false
      isRemoved: true
      updatedByUserId: this.userId

    BuildingReviews.update reviewId, modifier