publishedBuildingFields = ['address', 'postalCode', 'cityId', 'title', 'images', 'features', 'isPublished', 'position', 'parentId', 'btype', 'isOnMap', 'latitude',
  'longitude', 'slug', 'neighborhood', 'neighborhoodSlug', 'fitnessCenter', 'security', 'laundry', 'parking', 'pets', 'utilities',
  'agroIsUnit', 'agroPriceTotalFrom', 'agroPriceTotalTo', 'agroPriceStudioFrom', 'agroPriceStudioTo', 'agroPriceBedroom0From',
  'agroPriceBedroom0To', 'agroPriceBedroom1From', 'agroPriceBedroom1To', 'agroPriceBedroom2From', 'agroPriceBedroom2To',
  'agroPriceBedroom3From', 'agroPriceBedroom3To', 'agroPriceBedroom4From', 'agroPriceBedroom4To', 'agroPriceBedroom5From',
  'agroPriceBedroom5To', 'agroPriceBedroom6From', 'agroPriceBedroom6To', 'averageRating', 'bathroomsFrom', 'bathroomsTo',
  'brokerageName', 'availableAt', 'modifiedAt', 'petsComment', 'parkingComment', 'utilitiesComment', 'laundryComment',
  'securityComment', 'fitnessCenterComment', 'isFurnished', 'sqftFrom', 'sqftTo', 'vimeoId', 'bedroomsFrom', 'bedroomsTo', 'source']

publishedAdminBuildingFields = publishedBuildingFields.concat ['mlsNo', 'adminAvailability', 'adminEscorted', 'adminAppFee', 'adminAvailability', 'adminOfficeHours',
  'adminScheduling', 'adminContact', 'adminNotes']

appendToSelector = (object, field) -> object[field] = 1; object
publishedBuildingFieldsSelector = _.reduce publishedBuildingFields, appendToSelector, {}
publishedAdminBuildingFieldsSelector = _.reduce publishedAdminBuildingFields, appendToSelector, {}

addIsPublishedFilter = (userId, selector) ->
  unless Security.canOperateWithBuilding(userId)
    selector.isPublished = true

addWithImagesFilter = (selector) ->
  selector.images = { $exists: true, $ne: [] }

getBuildingSelector = (userId, cityId, query, mapBounds) ->
  selector = {parentId: {$exists: false}, cityId: cityId}
  addQueryFilter(query, selector, userId)
  addIsPublishedFilter(userId, selector)
  addWithImagesFilter(selector)
  addMapBoundsFilter(mapBounds, selector)
  selector

Meteor.publish "currentUser", ->
  Meteor.users.find {_id: @userId},
    fields:
      "role": 1
      "username": 1
      "isAliasedByMixpanel": 1
      "profile": 1
      "createdAt": 1
      "isNew": 1

wait = Meteor.wrapAsync((sec, cb) -> setTimeout((-> cb(null)), sec * 1000))

Meteor.publish "allUsers", ->
  unless @userId
    return []
  # CC9 6/3/16): Only want to return users that have a NAME - what is the syntax for that here?
  Meteor.users.find()

Meteor.smartPublish "buildings", (cityId, query, mapBounds, page = 1) ->
  check cityId, Match.InArray(cityIds)
  check query, Object
  check mapBounds, Object
  check page, Number

  fields = if Security.canOperateWithBuilding @userId then publishedAdminBuildingFieldsSelector else publishedBuildingFieldsSelector
  selector = getBuildingSelector @userId, cityId, query, mapBounds
  sort = {position: -1, createdAt: -1, _id: 1}
  limit = page * itemsPerPage

  @addDependency "buildings", "images", (building) ->
    images = building.images or []
    image = _.first images
    BuildingImages.find {_id: image._id}, {fields: 'copies': 1} if image

  Buildings.find selector, {sort, limit, fields}

Meteor.publish "buildingsSimilar", (buildingId) ->
  building = Buildings.findOne(buildingId)

  from = building.agroPriceTotalTo - 300
  to = building.agroPriceTotalTo + 300
  selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}

  addWithImagesFilter(selector)

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
      images = BuildingImages.find {_id: $in: imageIds}, {fields: 'copies.thumbsSmall': 1}

  [similarBuildingsCursor, images]

Meteor.smartPublish "recommendedBuildings", (buildingIds) ->
  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id

    if _id then [BuildingImages.find(_id)] else []

  Buildings.find({_id: {'$in': buildingIds}}, {sort: {position: -1, createdAt: -1, _id: 1}})

Meteor.publish "buildingImages", (buildingId) ->
  building = Buildings.findOne(buildingId, {images: 1})

  images = building.images or []
  imageIds = _.pluck images, "_id"
  BuildingImages.find({_id: {$in: imageIds}})

Meteor.publish "city-buildings-count", (cityId, query = {}, mapBounds) ->
  check(cityId, Match.InArray(cityIds))
  selector = getBuildingSelector @userId, cityId, query, mapBounds
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
  # addIsPublishedFilter(@userId, selector)
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
  addIsPublishedFilter(@userId, selector)
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
  addIsPublishedFilter(@userId, selector)
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
  addIsPublishedFilter(@userId, selector)
  [Buildings.find(selector)]

Meteor.publish "allBuildings", ->
  if Security.canOperateWithBuilding(@userId)
    Buildings.find()
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
