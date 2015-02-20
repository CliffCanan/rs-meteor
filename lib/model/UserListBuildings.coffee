bTypes = ["studio", "1bedroom", "2bedroom", "3bedroom", "4bedroom", "5bedroom"]

class UserListBuilding
  constructor: (doc) ->
    _.extend(@, doc)
  cityName: ->
    cities[@cityId].short
  bedroomTypes: ->
    types = []
    postfix = ""
    if @studio
      types.push("Studio")
    if @["1bedroom"]
      types.push(1)
      postfix = " Bedroom"
    for i in [2..5]
      if @[bTypes[i]]
        types.push(i)
        postfix = " Bedrooms"
    types.join(", ") + postfix
  priceFrom: ->
    from = []
    for type in bTypes
      obj = @[type]
      if obj?.from
        from.push(obj.from)
    if from.length
      "$" + Math.max.apply(null, from) + (if from.length > 1 then "+" else "")

share.Transformations.UserListBuilding = _.partial(share.transform, UserListBuilding)

@UserListBuildings = new Mongo.Collection "userListBuildings",
  transform: if Meteor.isClient then share.Transformations.UserListBuilding else null

userListBuildingPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = now

UserListBuildings.before.insert (userId, userListBuilding) ->
  userListBuilding._id ||= Random.id()
  now = new Date()
  userListBuilding = _.extend userListBuilding,
    ownerId: userId
    createdAt: now
  userListBuildingPreSave.call(@, userId, userListBuilding)
  true

UserListBuildings.before.update (userId, userListBuilding, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  userListBuildingPreSave.call(@, userId, modifier.$set)
  true
