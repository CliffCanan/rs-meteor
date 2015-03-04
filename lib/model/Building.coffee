complexFieldsValues =
  pets: ["Unknown", "Pets Allowed", "Some Pets Allowed", "No Pets"]
  parking: ["Unknown", "Parking Included", "Parking Available", "No Parking"]
  laundry: ["Unknown", "In-unit Laundry", "Shared Laundry", "No Laundry"]
  security: ["Unknown", "Doorman", "No Doorman"]
  utilities: ["Unknown", "Utilities Included", "Utilities Extra"]
  fitnessCenter: ["Unknown", "Fitness Center", "No Fitness Center"]

formatPriceDisplay = (from, to) ->
  price = ""
  if from
    price += "$" + from
    if to
      if to isnt from
        price += "-" + to
    else
      price += "+"
  price


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
  getFeatures: ->
    if @features?.length then @features else @parent()?.features
  getAvailableAt: ->
    if @agroIsUnit # and @availableAt > new Date()
      @availableAt
  getBedrooms: ->
    if @bedroomsFrom
      value = @bedroomsFrom
      unless @bedroomsFrom is @bedroomsTo
        value += " - " + @bedroomsTo
      value += " Bedroom"
      if @bedroomsTo > 1
        value += "s"
      value
  getBathrooms: ->
    if @bathroomsFrom
      value = @bathroomsFrom
      unless @bathroomsFrom is @bathroomsTo
        value += " - " + @bathroomsTo
      value += " Bathroom"
      if @bathroomsTo > 1
        value += "s"
      value
    else if @agroIsUnit or @prices().length > 1
      "Bathrooms: Varies"
    else
      "Bathrooms: Please inquire"
  getUnitTitle: ->
    title = @title
    parent = @parent()
    if parent
      title = parent.title + " " + title
    title
  getUnitPrice: ->
    if @priceFrom
      price: formatPriceDisplay(@priceFrom, @priceTo)
      type: btypes[@btype]?.lower
  complexFields: ->
    fields = []
    for field in ["pets", "parking", "laundry", "security", "utilities", "fitnessCenter"]
      key = @[field] ? @parent()?[field]
      if key
        value = complexFieldsValues[field][key]
        comment = @[field + "Comment"] ? @parent()?[field + "Comment"]
        isAvailable = value.indexOf("No") is -1 and value.indexOf("Extra") is -1
        isGreyCheck = value is "Some Pets Allowed" or value is "Shared Laundry"
        if isAvailable
          if isGreyCheck
            iconClass = "fa-check grey-icon"
          else
            iconClass = "fa-check blue-icon"
        else
          iconClass = "fa-times grey-icon"
        fields.push
          field: field
          value: value
          comment: comment
          isAvailable: isAvailable
          iconClass: iconClass

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
  buildingUnits: ->
    Buildings.find({parentId: @_id}, {sort: {createdAt: -1, _id: 1}})
  parent: ->
    Buildings.findOne(@parentId)  if @parentId
  prices: ->
    prices = []
    for key, value of btypes
      fieldName = "agroPrice" + key.charAt(0).toUpperCase() + key.slice(1)
      fromFieldName = fieldName + "From"
      toFieldName = fieldName + "To"
      if @[fromFieldName]
        prices.push
          price: formatPriceDisplay(@[fromFieldName], @[toFieldName])
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
