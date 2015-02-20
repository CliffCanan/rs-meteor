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

Meteor.publish "buildings", (cityId, buildingSlug) ->
  check(cityId, Match.InArray(cityIds))
  check(buildingSlug, Match.Optional(String))
  selector = {cityId: cityId}
  if buildingSlug
    selector.slug = buildingSlug
  Buildings.find(selector)

Meteor.publish "allBuildings", ->
  Buildings.find()

Meteor.publish "userListBuildings", (userListId)->
  check(userListId, Match.Any)
  userList = UserLists.findOne({_id:userListId})
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
