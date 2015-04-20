class PropertyList
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.PropertyList = _.partial(share.transform, PropertyList)

@PropertyLists = new Mongo.Collection "propertyLists"
#   transform: if Meteor.isClient then share.Transformations.PropertyList else null

# PropertyListPreSave = (userId, changes) ->
#   now = new Date()
#   changes.updatedAt = now

# PropertyLists.before.insert (userId, PropertyList) ->
#   PropertyList._id ||= Random.id()
#   now = new Date()
#   _.extend PropertyList,
#     createdAt: now
#   PropertyListPreSave.call(@, userId, PropertyList)
#   true

# PropertyLists.before.update (userId, PropertyList, fieldNames, modifier, options) ->
#   modifier.$set = modifier.$set or {}
#   PropertyListPreSave.call(@, userId, modifier.$set)
#   true
