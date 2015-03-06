addIsPublishFilter = (userId, selector) ->
  user = Meteor.users.findOne(userId)
  unless user?.role is "admin"
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

Meteor.smartPublish "buildings", (cityId, page) ->
  check(cityId, Match.InArray(cityIds))
  check(page, Number)
  page = parseInt(page)
  unless page > 0
    page = 1
  limit = page * itemsPerPage

  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []
  selector = {parentId: {$exists: false}, cityId: cityId}
  addIsPublishFilter(@userId, selector)
  Buildings.find(selector, {limit: limit, sort: {createdAt: -1, _id: 1}})

Meteor.publish "city-buildings-count", (cityId) ->
  check(cityId, Match.InArray(cityIds))
  selector = {parentId: {$exists: false}, cityId: cityId}
  addIsPublishFilter(@userId, selector)
  Counts.publish(@, "city-buildings-count", Buildings.find(selector))
  undefined

Meteor.smartPublish "building", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]
  selector = {cityId: cityId, slug: slug}
  addIsPublishFilter(@userId, selector)
  Buildings.find(selector)

Meteor.smartPublish "buildingParent", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  childBuilding = Buildings.findOne({cityId: cityId, slug: slug})
  return [] if not childBuilding
  if childBuilding.parentId
    @addDependency "buildings", "images", (building) ->
      imageIds = _.map building.images, (file) ->
        file._id
      [BuildingImages.find({_id: {$in: imageIds}})]
    selector = {_id: childBuilding.parentId}
    addIsPublishFilter(@userId, selector)
    [Buildings.find({_id: childBuilding.parentId})]
  else
    []

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

Meteor.publish "allBuildings", ->
  user = Meteor.users.findOne(@userId)
  if user?.role is "admin"
    Buildings.find()
  else
    []

Meteor.publish "userListBuildings", (userListId)->
  check(userListId, Match.Any)
  userList = UserLists.findOne({_id:userListId})
  if userList
    Buildings.find({_id: {$in: userList.buildingsIds}})

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
