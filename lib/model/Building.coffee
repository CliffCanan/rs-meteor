complexFieldsValues =
  pets: ["Unknown", "Pets Allowed", "Pets Allowed", "Pets Not Allowed"]
  parking: ["Unknown", "Parking Included", "Parking Available", "No Parking"]
  laundry: ["Unknown", "In-unit Laundry", "On-site Laundry", "No Laundry"]
  security: ["Unknown", "Doorman", "No Doorman"]
  utilities: ["Unknown", "Utilities Included", "Utilities Extra Charge"]
  fitnessCenter: ["Unknown", "Fitness Center", "No Fitness Center"]

class Building
  constructor: (doc) ->
    _.extend(@, doc)
  cityName: ->
    cities[@cityId].short
  mainImage: ->
    file = @getImages()?[0]
    file  if file?.url
  getImages: ->
    if @images?.length
      @images
    else
      @parent()?.images
  getDescription: ->
    @description ? @parent()?.description
  complexFields: ->
    fields = []
    for field in ["pets", "parking", "laundry", "security", "utilities", "fitnessCenter"]
      key = @[field] ? @parent()?[field]
      if key
        value = complexFieldsValues[field][key]
        comment = @[field + "Comment"] ? @parent()?[field + "Comment"]
        fields.push
          field: field
          value: value
          comment: comment
          isAvailable: value.indexOf("No") is -1
    fields
  bedroomTypes: ->
    if @agroIsUnit
      btypes[@btype]?.upper
    else
      types = []
      postfix = ""
      if @priceStudioFrom
        types.push("Studio")
      if @priceBedroom1From
        types.push(1)
        postfix = " Bedroom"
      for i in [2..5]
        if @["priceBedroom" + i + "From"]
          types.push(i)
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
    prices = []
    for key, value of btypes
      fieldName = "price" + key.charAt(0).toUpperCase() + key.slice(1)
      fromFieldName = fieldName + "From"
      toFieldName = fieldName + "To"
      if @[fromFieldName]
        prices.push
          from: "$" + @[fromFieldName] + (if @[fromFieldName] is @[toFieldName] then "" else "+")
          type: value.lower
    prices


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
