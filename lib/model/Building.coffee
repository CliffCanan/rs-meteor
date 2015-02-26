class Building
  constructor: (doc) ->
    _.extend(@, doc)
  cityName: ->
    cities[@cityId].short
  mainImage: ->
    file = @images?[0]?.getFileRecord()
    file  if file?.url
  bedroomTypes: ->
    types = []
    postfix = ""
    if @studio
      types.push("Studio")
    if @bedroom1
      types.push(1)
      postfix = " Bedroom"
    for i in [1..4]
      if @[btypesIds[i]]
        types.push(i + 1)
        postfix = " Bedrooms"
    types.join(", ") + postfix
  priceFrom: ->
    fromCount = 0
    for type in btypesIds
      obj = @[type]
      if obj?.from
        fromCount++
    if fromCount
      "$" + @priceMin + (if fromCount > 1 then "+" else "")
  buildingUnits: ->
    Buildings.find({parentId: @_id}, {sort: {createdAt: -1, _id: 1}})
  parent: ->
    Buildings.findOne(@parentId)  if @parentId

share.Transformations.Building = _.partial(share.transform, Building)

@Buildings = new Mongo.Collection "buildings",
  transform: if Meteor.isClient then share.Transformations.Building else null

buildingPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = now

Buildings.before.insert (userId, building) ->
  building._id ||= Random.id()
  now = new Date()
  _.extend building,
    ownerId: userId
    createdAt: now
  buildingPreSave.call(@, userId, building)
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  buildingPreSave.call(@, userId, modifier.$set)
  true
