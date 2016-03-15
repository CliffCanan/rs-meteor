addIsPublishFilter = (userId, selector) ->
  unless Security.canOperateWithBuilding(userId)
    selector.isPublished = true

Meteor.publish "currentUser", ->
  Meteor.users.find {_id: @userId},
    fields:
      "username": 1
      "isAliasedByMixpanel": 1
      "profile": 1
      "createdAt": 1
      "isNew": 1

wait = Meteor.wrapAsync((sec, cb) -> setTimeout((-> cb(null)), sec * 1000))

Meteor.publish "allUsers", ->
  unless @userId
    return []
  Meteor.users.find()

Meteor.publish "buildings", (cityId, query, page) ->
  query.from = "" + query.from
  query.to = "" + query.to
  check(cityId, Match.InArray(cityIds))
  check(page, Number)
  ### check query,
    btype: Match.Optional(Match.InArray(btypesIds))
    from: Match.Optional(String)
    to: Match.Optional(String)
    q: Match.Optional(String)
    security: Match.Optional(String)
    fitnessCenter: Match.Optional(String)
    pets: Match.Optional(String)
    laundry: Match.Optional(String)
    parking: Match.Optional(String)
    utilities: Match.Optional(String)
    available: Match.Optional(String)
    neighborhoodSlug: Match.Optional(String)
    address: Match.Optional(String)
    utm_source: Match.Optional(String)
    utm_medium: Match.Optional(String)
    utm_content: Match.Optional(String)
    utm_campaign: Match.Optional(String)
    listingType: Match.Optional(String) ###

  page = parseInt(page)
  unless page > 0
    page = 1
  limit = page * itemsPerPage

  selector = {parentId: {$exists: false}, cityId: cityId}
  addQueryFilter(query, selector, @userId)
  addIsPublishFilter(@userId, selector)

  # Limit fields to only those needed to display on city listing. Other fields are for building page.
  fields =
    address: 1
    postalCode: 1
    cityId: 1
    title: 1
    images: 1
    features: 1
    isPublished: 1
    position: 1
    parentId: 1
    btype: 1
    isOnMap: 1
    latitude: 1
    longitude: 1
    slug: 1
    neighborhood: 1
    neighborhoodSlug: 1
    fitnessCenter: 1
    security: 1
    laundry: 1
    parking: 1
    pets: 1
    utilities: 1
    agroIsUnit: 1
    agroPriceTotalFrom: 1
    agroPriceTotalTo: 1
    agroPriceStudioFrom: 1
    agroPriceStudioTo: 1
    agroPriceBedroom1From: 1
    agroPriceBedroom1To: 1
    agroPriceBedroom2From: 1
    agroPriceBedroom2To: 1
    agroPriceBedroom3From: 1
    agroPriceBedroom3To: 1
    agroPriceBedroom4From: 1
    agroPriceBedroom4To: 1
    agroPriceBedroom5From: 1
    agroPriceBedroom5To: 1
    agroPriceBedroom6From: 1
    agroPriceBedroom6To: 1
    averageRating: 1
    bathroomsFrom: 1
    bathroomsTo: 1
    brokerageName: 1

  fields['source.source'] = 1

  if Security.canOperateWithBuilding(@userId)
    adminFields = {
      title: 1
      mlsNo: 1
      adminAvailability: 1
      adminEscorted: 1
      adminAppFee: 1
      adminAvailability: 1
      adminScheduling: 1
      adminContact: 1
      adminNotes: 1
    }
    fields = _.extend fields, adminFields

  buildingsCursor = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: limit, fields: fields})
  buildings = buildingsCursor.fetch()

  cursors = []

  cursors.push buildingsCursor

  if buildings
    imageIds = []
    buildings.forEach (building) ->
      _id = building.images?[0]?._id
      imageIds.push _id

    if imageIds.length
      images = BuildingImages.find {_id: $in: imageIds}, {fields: 'copies.thumbs': 1}
      cursors.push images

  cursors

Meteor.publish "buildingsQuickView", (cityId, query, page) ->
  query.from = "" + query.from
  query.to = "" + query.to
  check(cityId, Match.InArray(cityIds))
  check(page, Number)
  ###check query,
    btype: Match.Optional(Match.InArray(btypesIds))
    from: Match.Optional(String)
    to: Match.Optional(String)
    q: Match.Optional(String)
    security: Match.Optional(String)
    fitnessCenter: Match.Optional(String)
    pets: Match.Optional(String)
    laundry: Match.Optional(String)
    parking: Match.Optional(String)
    utilities: Match.Optional(String)
    available: Match.Optional(String)
    neighborhoodSlug: Match.Optional(String)
    address: Match.Optional(String)
    listingType: Match.Optional(String)###

  page = parseInt(page)
  unless page > 0
    page = 1
  limit = page * itemsPerPage

  selector = {cityId: cityId}
  addQueryFilter(query, selector, @userId, {q: true})
  addIsPublishFilter(@userId, selector)

  _.each (_.keys selector), (key) ->
    delete selector[key] if key.indexOf('agro') > -1

  # Limit fields to only those needed to display on city listing. Other fields are for building page.
  fields =
    cityId: 1
    title: 1
    images: 1
    isPublished: 1
    position: 1
    parentId: 1
    btype: 1
    isOnMap: 1
    latitude: 1
    longitude: 1
    slug: 1
    neighborhoodSlug: 1
    fitnessCenter: 1
    security: 1
    laundry: 1
    parking: 1
    pets: 1
    utilities: 1
    bedroomsFrom: 1
    bedroomsTo: 1
    bathroomsFrom: 1
    bathroomsTo: 1
    sqftFrom: 1
    sqftTo: 1
    agroIsUnit: 1
    agroPriceTotalFrom: 1
    agroPriceTotalTo: 1
    agroPriceStudioFrom: 1
    agroPriceStudioTo: 1
    agroPriceBedroom1From: 1
    agroPriceBedroom1To: 1
    agroPriceBedroom2From: 1
    agroPriceBedroom2To: 1
    availableAt: 1

  if Security.canOperateWithBuilding(@userId)
    adminFields = {
      title: 1
      mlsNo: 1
      adminAvailability: 1
      adminEscorted: 1
      adminAppFee: 1
      adminAvailability: 1
      adminScheduling: 1
      adminContact: 1
      adminNotes: 1
    }
    fields = _.extend fields, adminFields

  buildingsCursor = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, fields: fields})
  buildings = buildingsCursor.fetch()

  cursors = []

  cursors.push buildingsCursor

  if buildings
    imageIds = []
    buildings.forEach (building) ->
      _id = building.images?[0]?._id
      imageIds.push _id

    if imageIds.length
      images = BuildingImages.find {_id: $in: imageIds}, {fields: 'copies.thumbs': 1}
      cursors.push images

  cursors

Meteor.publish "buildingsSimilar", (buildingId) ->
  building = Buildings.findOne(buildingId)

  from = building.agroPriceTotalTo - 300
  to = building.agroPriceTotalTo + 300
  selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}

  # Limit fields to only those needed to display on similar properties block
  fields =
    cityId: 1
    title: 1
    images: 1
    isPublished: 1
    btype: 1
    slug: 1
    neighborhoodSlug: 1
    bathroomsTo: 1
    parentId: 1
    agroIsUnit: 1
    agroPriceTotalFrom: 1
    agroPriceTotalTo: 1
    agroPriceStudioFrom: 1
    agroPriceStudioTo: 1
    agroPriceBedroom1From: 1
    agroPriceBedroom1To: 1
    agroPriceBedroom2From: 1
    agroPriceBedroom2To: 1

  similarBuildingsCursor = Buildings.find(selector, {limit: 4, fields: fields})
  similarBuildings = similarBuildingsCursor.fetch()

  images = []

  if similarBuildings
    imageIds = []
    similarBuildings.forEach (building) ->
      _id = building.images?[0]?._id
      imageIds.push _id

    if imageIds.length
      images = BuildingImages.find {_id: $in: imageIds}, {fields: 'copies.thumbs': 1}

  [similarBuildingsCursor, images]

Meteor.smartPublish "recommendedBuildings", (buildingIds) ->
  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []

  Buildings.find({_id: {'$in': buildingIds}}, {sort: {position: -1, createdAt: -1, _id: 1}})

Meteor.publish "buildingImages", (buildingId) ->
  building = Buildings.findOne(buildingId)
  if building.images?
    imageIds = _.map building.images, (file) ->
      file._id
    return BuildingImages.find({_id: {$in: imageIds}})
  else
    @ready

Meteor.publish "city-buildings-count", (cityId, query) ->
  check(cityId, Match.InArray(cityIds))
  selector = {parentId: {$exists: false}, cityId: cityId}
  addQueryFilter(query, selector)
  addIsPublishFilter(@userId, selector)
  Counts.publish(@, "city-buildings-count", Buildings.find(selector))
  undefined

Meteor.publish "singleBuilding", (buildingId) ->
  Buildings.find(buildingId)

Meteor.smartPublish "building", (cityId, slug) ->
  # console.log("cityId: ", cityId)
  # console.log("slug: ", slug)
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]

  selector = {cityId: String(cityId), slug: String(slug)}
  # addIsPublishFilter(@userId, selector)
  buildings = Buildings.find(selector)

  # console.log("buildings: ", buildings.fetch())
  buildings

Meteor.smartPublish "buildingParent", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  childBuilding = Buildings.findOne({cityId: cityId, slug: slug})
  return [] if not childBuilding
  @addDependency "buildings", "parentId", (building) ->
    parent = Buildings.findOne(building.parentId)
    if parent
      imageIds = _.map parent.images, (file) ->
        file._id
      [
        Buildings.find({_id: building.parentId})
        BuildingImages.find({_id: {$in: imageIds}})
      ]
    else
      []
  selector = {_id: childBuilding._id}
  addIsPublishFilter(@userId, selector)
  [Buildings.find(selector)]

Meteor.publish "buildingReviews", (buildingId) ->
  BuildingReviews.find({buildingId: buildingId, isPublished: true, isRemoved: null})

Meteor.publish "buildingForSimilar", (buildingId) ->
  fields =
    cityId: 1
    bathroomsTo: 1
    agroPriceTotalTo: 1
    agroPriceTotalTo: 1

  Buildings.find(buildingId, {fields: fields})

Meteor.smartPublish "buildingUnits", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  parentBuilding = Buildings.findOne({cityId: cityId, slug: slug})
  return [] if not parentBuilding
  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]
  selector = {parentId: parentBuilding._id}
  addIsPublishFilter(@userId, selector)
  [Buildings.find(selector)]

Meteor.smartPublish "buildingAdminSame", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  building = Buildings.findOne({cityId: cityId, slug: slug})
  return []  unless building
  @addDependency "buildings", "parentId", (building) ->
    parent = Buildings.findOne(building.parentId)
    if parent
      if parent.adminSameId
        Buildings.find({_id: parent.adminSameId})
      else
        Buildings.find({_id: parent._id})
    else
      Buildings.find({_id: building.adminSameId})
  selector = {_id: building._id}
  addIsPublishFilter(@userId, selector)
  [Buildings.find(selector)]

Meteor.publish "allBuildings", ->
  if Security.canOperateWithBuilding(@userId)
    Buildings.find()
  else
    []

Meteor.publish "allBuildingsQuickView", ->
  if Security.canOperateWithBuilding(@userId)
    fields =
      cityId: 1
      title: 1
      images: 1
      isPublished: 1
      position: 1
      parentId: 1
      btype: 1
      isOnMap: 1
      latitude: 1
      longitude: 1
      slug: 1
      neighborhoodSlug: 1
      fitnessCenter: 1
      security: 1
      laundry: 1
      parking: 1
      pets: 1
      utilities: 1
      bedroomsFrom: 1
      bedroomsTo: 1
      bathroomsFrom: 1
      bathroomsTo: 1
      sqftFrom: 1
      sqftTo: 1
      agroIsUnit: 1
      agroPriceTotalFrom: 1
      agroPriceTotalTo: 1
      agroPriceStudioFrom: 1
      agroPriceStudioTo: 1
      agroPriceBedroom1From: 1
      agroPriceBedroom1To: 1
      agroPriceBedroom2From: 1
      agroPriceBedroom2To: 1
      availableAt: 1

    Buildings.find({}, {fields: fields})
  else
    []

Meteor.publish "userListBuildings", (userListId)->
  check(userListId, Match.Any)
  userList = UserLists.findOne({_id:userListId})
  if userList
    Buildings.find({_id: {$in: userList.buildingsIds}})

Meteor.publish "propertyListBuildings", (slug)->
  check(slug, Match.Any)
  propertyList = PropertyLists.findOne({slug: String(slug)})
  # console.log("publish > propertyList: ", propertyList)
  # console.log("puglish > buildings: ", Buildings.find({_id: {$in: propertyList.buildings}}).fetch())
  if propertyList
    Buildings.find({_id: {$in: propertyList.buildings}})

Meteor.publish "CheckAvailabilityRequests", ->
  unless @userId
    return []
  CheckAvailabilityRequests.find()

Meteor.publish "ContactUsRequests", ->
  unless @userId
    return []
  ContactUsRequests.find()

Meteor.publish "UserLists", ->
  UserLists.find()

Meteor.publish "ClientRecommendations", ->
  ClientRecommendations.find()

Meteor.publish "singleClientRecommendation", (clientRecommendationId) ->
  ClientRecommendations.find(clientRecommendationId)

Meteor.publish "propertyLists", ->
  PropertyLists.find()

Meteor.publish "vimeoVideos", ->
  unless @userId
    return []
  VimeoVideos.find()

Meteor.smartPublish "pendingReviews", ->
  @addDependency "buildingReviews", "buildingId", (review) ->
    [Buildings.find(review.buildingId)]

  BuildingReviews.find({isPublished: false, isRemoved: null})

Meteor.publish null, ->
  if this.userId
    Counts.publish(@, "pendingReviewsCount", BuildingReviews.find({isPublished: false, isRemoved: null}))
    Counts.publish(@, "rentalApplicationsCount", RentalApplications.find())
  null

Meteor.smartPublish "rentalApplications", ->
  @addDependency "rentalApplications", "documents", (rentalApplication) ->
    documentIds = _.map rentalApplication.documents, (file) ->
      file._id
    [RentalApplicationDocuments.find({_id: {$in: documentIds}})]

  RentalApplications.find({}, {fields: {password: 0}})

Meteor.smartPublish "rentalApplication", (id, accessToken) ->
  publish = []
  accesss = false
  accessAllDocuments = false
  if Security.canOperateWithBuilding(this.userId)
    access = true
    accessAllDocuments = true
  else
    rentalApplication = RentalApplications.findOne(id, {fields: {accessToken: 1, hasPassword: 1}})
    access = true if rentalApplication.accessToken is accessToken or not rentalApplication.hasPassword

  if access
    @addDependency "rentalApplications", "documents", (rentalApplication) ->
      documentIds = _.map rentalApplication.documentsFromAdmin, (file) ->
        file._id

      documentsSelector = {}
      if not accessAllDocuments
        documentsSelector.canUserView = true

      [RentalApplicationDocuments.find(documentsSelector)]

    publish.push RentalApplications.find(id, {fields: {password: 0}})
    publish.push RentalApplicationRevisions.find({parentId: id}, {fields: {parentId: 1, updateNote: 1, revisionSavedAt: 1}})
  else
    publish.push RentalApplications.find(id, {fields: {accessToken: 1, hasPassword: 1}})

  publish
