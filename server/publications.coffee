Meteor.publish "currentUser", ->
  Meteor.users.find {_id: @userId},
    fields:
      "username": 1
      "isAliasedByMixpanel": 1
      "profile": 1
      "createdAt": 1
      "isNew": 1


Meteor.publish "allUsers", ->
  unless @userId
    return []
  Meteor.users.find()

Meteor.smartPublish "buildings", (cityId, page) ->
  page ?= 0
  check(cityId, Match.InArray(cityIds))

  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []
  cl "page", page
  Buildings.find({parentId: {$exists: false}, cityId: cityId}, {skip: (if page > 0 then ((page-1)*2) else 0), limit:2})

Meteor.smartPublish "building", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]
  Buildings.find({cityId: cityId, slug: slug})

Meteor.smartPublish "buildingParent", (cityId, slug) ->
  check(cityId, Match.InArray(cityIds))
  check(slug, String)
  childBuilding = Buildings.findOne({cityId: cityId, slug: slug})
  return [] if not childBuilding
  if childBuilding.parentId
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
  [Buildings.find({parentId: parentBuilding._id})]

Meteor.publish "allBuildings", ->
  Buildings.find()

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
