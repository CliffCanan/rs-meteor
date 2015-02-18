bTypes = ["studio", "1bedroom", "2bedroom", "3bedroom", "4bedroom", "5bedroom"]

class Building
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

share.Transformations.Building = _.partial(share.transform, Building)

@Buildings = new Mongo.Collection "buildings",
  transform: if Meteor.isClient then share.Transformations.Building else null

buildingPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = now

Buildings.before.insert (userId, building) ->
  building._id ||= Random.id()
  now = new Date()
  building = _.extend building,
    ownerId: userId
    createdAt: now
  buildingPreSave.call(@, userId, building)
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  buildingPreSave.call(@, userId, modifier.$set)
  true
