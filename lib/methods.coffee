# Methods can be called from both client and server to take advantage of latency compensation. Server only methods are below.
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

  "createClient": (clientName) ->
    return {message: "error", reason: "no permissions", 0} unless Security.canManageClients()
    firstName = clientName
    [firstName, lastName] = firstName.split ' '
    fields =
      name: clientName
      firstName: firstName
      lastName: lastName
      buildingIds: []
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

  "processRentalApplicationPassword": (params) ->
    id = params.id
    password = params.password
    rentalApplication = RentalApplications.findOne(id)
    if rentalApplication
      if rentalApplication.password is password
        accessToken = Random.secret()
        RentalApplications.update(id, {$set: {accessToken: accessToken}})
        result =
          success: true
          accessToken: accessToken
      else
        result =
          success: false
          message: 'Incorrect password'
    else
      result =
        success: false
        message: 'Rental application not found'

    result

  "revertRentalApplication": (revisionId) ->
    previousRentalApplication = RentalApplicationRevisions.findOne(revisionId)
    parentId = previousRentalApplication.parentId
    processedRentalApplication = _.omit(previousRentalApplication, ['_id', 'parentId', 'revisionSavedAt'])
    processedRentalApplication.isNewRevision = true
    processedRentalApplication.updateNote = "Revert to '#{previousRentalApplication.updateNote}'"
    RentalApplications.update parentId, $set: processedRentalApplication

if Meteor.isServer
  Meteor.methods
    syncMLS: ->
      importer = new MLSImporter()
      importer.sync Meteor.settings.trendrets.query

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

      console.log "====== Start importImagesByBatch ======"

      clientId = uploadObject.clientId

      for object in uploadObject.buildings
        index = 0
        buildingId = object.buildingId
        console.log "====== Importing images for building id: #{buildingId} ======"
        console.log "importImage > buildingId: " + buildingId
        if object.images
          request = Meteor.npmRequire 'request'
          for uri in object.images
            try
              # With the new MLS, we have to request for each image directly
              # The insert URL function for CollectionFS uses a HEAD request to query the URL and MLS returns a 404
              # We'll have to use our own GET request instead
              request.get({url: uri, encoding: null}, Meteor.bindEnvironment (e, r, buffer) ->
                file = new FS.File()
                file.attachData buffer, {type: 'image/jpeg'}, (error) ->
                  throw error if error
                  file.name "#{buildingId}_#{index}.jpeg";

                  BuildingImages.insert file, (error, fileObj) ->
                    fileObj = _.omit(fileObj, 'collection')
                    Buildings.update(_id: buildingId, {$addToSet: {images: fileObj}})
                    index++
                    Meteor.sleep 1500
                  Meteor.sleep 1500
              )
              Meteor.sleep 1500
            catch error
              console.error error.stack()
        # All images imported for this building. Mark it as complete and it will appear in the list.
        Buildings.update(buildingId, {$set: {isImportCompleted: true, isPublished: true}})
        console.log "====== All images for building id: #{buildingId} imported ======"

      ClientRecommendations.update(clientId, {$set: {importCompletedAt: new Date()}})
      console.log "====== End importImagesByBatch ======"
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

    "importPropertyFromIDX": (property, options) ->
      return {message: "error", reason: "no permissions", 0} unless Security.canOperateWithBuilding()

      if not cities[property.cityId]
        return status: 400, message: "City #{property.cityId} not in our list", buildingId: property._id, mlsNo: property.source.mlsNo

      # Check if property exists
      building = Buildings.findOne({'source.mlsNo': property.source.mlsNo}, {fields: {_id: 1}})

      if building
        buildingId = building._id

      if options and options.forceUpdate is true
        if building.images
          _.each building.images (buildingImage) ->
            BuildingImages.remove(buildingImage._id)
        Buildings.remove(buildingId)
        property._id = buildingId
      else
        message = "Found existing building with id #{buildingId}"
        console.log message
        return status: 204, message: message, buildingId: buildingId, mlsNo: property.source.mlsNo

      Future = Npm.require('fibers/future')
      fut = new Future()

      try
        buildingId = Promise.await Buildings.insert property
        message = "Inserted new building with id #{buildingId}"
        console.log message
      catch error
        console.log error.message

      RETS = Meteor.npmRequire('rets-client');
      clientSettings =
        loginUrl: Meteor.settings.private.TrendIDX.loginUrl,
        username: Meteor.settings.private.TrendIDX.username,
        password: Meteor.settings.private.TrendIDX.password,
        version:'RETS/1.7.2'
        userAgent: "MRIS Conduit/2.0"

      @unblock()
      console.log "Getting photos for building with ListingKey: #{property.source.listingKey}"
      RETS.getAutoLogoutClient clientSettings, Meteor.bindEnvironment (client) ->
        return client.objects.getPhotos("Property", "Photo", property.source.listingKey)
        .then Meteor.bindEnvironment (photos) ->
          i = 1
          console.log "Received #{photos.length} objects."
          _.each photos, (photo) ->
            photoFuture = new Future()

          if photo.buffer
            newFile = new FS.File()
            Promise.await newFile.attachData photo.buffer, type: photo.mime
            extension = photo.mime.split('/')[1]
            fileName = "#{property._id}_#{photo.objectId}.#{extension}"
            newFile.name(fileName)
            Meteor.sleep 500
            file = Promise.await BuildingImages.insert newFile
            Buildings.update(_id: buildingId, {$addToSet: {images: file}})
            Meteor.sleep 500
            console.log "Saving #{fileName} - #{i} / #{photos.length} photos."
            i++
            Meteor.sleep 500
            photoFuture.return('done')
          else
            photoFuture.return status: 400, message: photo.error.message, buildingId: property._id, mlsNo: property.source.mlsNo

            photoFuture.wait()

          console.log "All photos processed for #{property._id}"
          fut.return status: 200, message: 'done', buildingId: property._id, mlsNo: property.source.mlsNo

        .catch Meteor.bindEnvironment (error) ->
          console.log error
          fut.return status: 400, message: error.message, buildingId: property._id, mlsNo: property.source.mlsNo

      .catch Meteor.bindEnvironment (error) ->
        console.log error
        fut.return status: 400, message: error.message, buildingId: property._id, mlsNo: property.source.mlsNo

      fut.wait()

  unpublishPropertiesFromIDX: (listingKeys) ->
    console.log("Unpublishing #{listingKeys.length} from IDX")
    Properties.update({'source.listingKey': {$in: listingKeys}}, {$set: {isPublished: false, 'source.isNotAvailableInIDX': true}})

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

  "getVimeoVideos": ->
    @unblock()
    Vimeo = Meteor.npmRequire('vimeo').Vimeo
    vimeo = new Vimeo(Meteor.settings.vimeo.clientId, Meteor.settings.vimeo.clientSecret, Meteor.settings.vimeo.accessToken)
    getVideoParams =
      method: 'GET'
      path: '/me/videos?per_page=50&filter_embeddable=true'

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

  "processRentalApplicationPassword": (params) ->
    id = params.id
    password = params.password
    rentalApplication = RentalApplications.findOne(id)
    if rentalApplication
      if rentalApplication.password is password
        accessToken = Random.secret()
        RentalApplications.update(id, {$set: {accessToken: accessToken}})
        result =
          success: true
          accessToken: accessToken
      else
        result =
          success: false
          message: 'Incorrect password'
    else
      result =
        success: false
        message: 'Rental application not found'

    result

  "revertRentalApplication": (revisionId) ->
    previousRentalApplication = RentalApplicationRevisions.findOne(revisionId)
    parentId = previousRentalApplication.parentId
    processedRentalApplication = _.omit(previousRentalApplication, ['_id', 'parentId', 'revisionSavedAt'])
    processedRentalApplication.isNewRevision = true
    processedRentalApplication.updateNote = "Revert to '#{previousRentalApplication.updateNote}'"
    RentalApplications.update parentId, $set: processedRentalApplication
