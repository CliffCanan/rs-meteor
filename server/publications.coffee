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

Meteor.smartPublish "buildings", (cityId, query, page) ->
  query.from = "" + query.from
  query.to = "" + query.to
  check(cityId, Match.InArray(cityIds))
  check(page, Number)
  check query,
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
    address: Match.Optional(String)

  page = parseInt(page)
  unless page > 0
    page = 1
  limit = page * itemsPerPage

  selector = {parentId: {$exists: false}, cityId: cityId}
  addQueryFilter(query, selector)
  addIsPublishFilter(@userId, selector)

  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []

  Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: limit})

Meteor.smartPublish "buildingsSimilar", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  selector = {cityId: cityId, slug: slug}
  #addIsPublishFilter(@userId, selector)
  building = Buildings.findOne(selector)

  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]

  from = building.agroPriceTotalTo - 200
  to = building.agroPriceTotalTo + 200
  selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}

  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []
  Buildings.find(selector, {limit: 4})

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

Meteor.smartPublish "buildingReviews", (cityId, slug) ->
  reviews = []
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  building = Buildings.findOne({cityId: cityId, slug: slug})
  #console.log building._id
  if building
    reviews = UserReviews.find({building: building._id})
    return reviews
  reviews


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
  VimeoVideos.find()