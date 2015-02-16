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

Meteor.publish "CheckAvailabilityRequests", ->
  unless @userId
    return []
  CheckAvailabilityRequests.find()
Meteor.publish "ContactUsRequests", ->
  unless @userId
    return []
  ContactUsRequests.find()
