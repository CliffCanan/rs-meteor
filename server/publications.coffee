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

Meteor.smartPublish "buildings", (cityId, limit = 90) ->
  check(cityId, Match.InArray(cityIds))

  @addDependency "buildings", "images", (building) ->
    _id = building.images?[0]?._id
    if _id then [BuildingImages.find(_id)] else []

  Buildings.find({cityId: cityId}) #, {limit: limit})

Meteor.smartPublish "building", (cityId, buildingSlug) ->
  check(cityId, Match.InArray(cityIds))
  check(buildingSlug, Match.Optional(String))

  @addDependency "buildings", "images", (building) ->
    imageIds = _.map building.images, (file) ->
      file._id
    [BuildingImages.find({_id: {$in: imageIds}})]

  Buildings.find({cityId: cityId})

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
