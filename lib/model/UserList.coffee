class UserList
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.UserList = _.partial(share.transform, UserList)

@UserLists = new Mongo.Collection "UserLists",
  transform: if Meteor.isClient then share.Transformations.UserList else null

UserListPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = now

UserLists.before.insert (userId, UserList) ->
  UserList._id ||= Random.id()
  now = new Date()
  _.extend UserList,
    createdAt: now
  UserListPreSave.call(@, userId, UserList)
  true

UserLists.before.update (userId, UserList, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  UserListPreSave.call(@, userId, modifier.$set)
  true
