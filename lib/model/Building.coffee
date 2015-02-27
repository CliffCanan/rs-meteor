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
  displayBuildingPrice: ->
    if @agroPriceTotalFrom
      "$" + @agroPriceTotalFrom + (if @agroPriceTotalFrom is @agroPriceTotalTo then "+" else "")
  displayUnitPrice: ->
    if @priceFrom
      "$" + @priceFrom + (if @priceFrom is @priceTo then "+" else "")
  buildingUnits: ->
    Buildings.find({parentId: @_id}, {sort: {createdAt: -1, _id: 1}})
  parent: ->
    Buildings.findOne(@parentId)  if @parentId
  prices: ->
    prices = {}
    units = @buildingUnits().fetch()
    bedroomTypesArray = ["studio", "bedroom1", "bedroom2", "bedroom3", "bedroom4", "bedroom5"]
    for type in bedroomTypesArray
      for unit in units
        if unit[type]?
            prices[type] ?= []
            prices[type].push(unit[type].from)
      if @[type]?
          prices[type] ?= []
          prices[type].push(@[type].from)
    minPrices = []
    for type in bedroomTypesArray
      if prices[type]?
        minPriceUnit = {}
        minPriceUnit.type = btypes[type]
        minPriceUnit.from = Math.min.apply(null, prices[type])
        minPrices.push(minPriceUnit)
    return minPrices


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
