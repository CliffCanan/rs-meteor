complexFieldsValues =
  pets:
    label: "Pets"
    values: ["Unknown", "Pets Allowed", "Some Pets Allowed", "No Pets"]
  parking:
    label: "Parking"
    values: ["Unknown", "Parking Included", "Parking Available", "No Parking"]
  laundry:
    label: "Laundry"
    values: ["Unknown", "In-unit Laundry", "Shared Laundry", "No Laundry"]
  security:
    label: "Security"
    values: ["Unknown", "Doorman", "No Doorman"]
  utilities:
    label: "Utilities"
    values: ["Unknown", "Utilities Included", "Utilities Extra"]
  fitnessCenter:
    label: "Fitness center"
    values: ["Unknown", "Fitness Center", "No Fitness Center"]

formatPriceDisplay = (from, to) ->
  price = ""
  if from
    price += "$" + accounting.formatNumber(from)
    if to
      if to isnt from
        price += "-" + accounting.formatNumber(to)
    else
      price += "+"
  price


class Building
  constructor: (doc) ->
    _.extend(@, doc)
  cityName: ->
    cities[@cityId].short
  getRouteData: ->
    data =
      cityId: @cityId
      neighborhoodSlug: @neighborhoodSlug
      buildingSlug: @slug
    if parent = @parent()
      data.buildingSlug = parent.slug
      data.unitSlug = @slug
    data
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
    if @agroIsUnit and @availableAt > new Date()
      @availableAt
  getAvailableAtForDatepicker: ->
    moment(@availableAt).format("MM/DD/YYYY")
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
#    else if @agroIsUnit or @prices().length > 1
#      "Bathrooms: Varies"
#    else
#      "Bathrooms: Please inquire"
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
  complexFields: (edit = false) ->
    fields = []
    for fieldName in ["laundry", "security", "fitnessCenter", "pets", "parking", "utilities"]
      value = @[fieldName]
      unless edit
        value = value or @parent()?[fieldName]
      if edit or value
        commentName = fieldName + "Comment"
        comment = @[commentName]
        unless edit
          comment = comment or @parent()?[fieldName + "Comment"]
        field =
          commentValue: comment
        if edit
          field.label = complexFieldsValues[fieldName].label
          values = for v, k in complexFieldsValues[fieldName].values
            name: fieldName
            value: k
            text: complexFieldsValues[fieldName].values[k]
            isChecked: k is value
          field.values = values
          field.commentName = commentName
        else
          text = complexFieldsValues[fieldName].values[value]
          field.text = text
          isAvailable = text.indexOf("No") is -1 and text.indexOf("Extra") is -1
          isGreyCheck = text is "Some Pets Allowed" or text is "Shared Laundry"
          if isAvailable
            if isGreyCheck
              iconClass = "fa-check grey-icon"
            else
              iconClass = "fa-check blue-icon"
          else
            iconClass = "fa-times grey-icon"
          field.isAvailable = isAvailable
          field.iconClass = iconClass
        fields.push(field)

    fields
  bedroomTypes: (queryBtype) ->
    if queryBtype
      if queryBtype is "studio"
        "Studio"
      else if queryBtype is "bedroom1"
        "1 Bedroom"
      else
        btypesIds.indexOf(queryBtype) + " Bedrooms"
    else
      if @agroIsUnit
        btypes[@btype]?.upper
      else
        types = []
        postfix = ""
        if @agroPriceStudioFrom
          types.push("Studio")
        if @agroPriceBedroom1From
          types.push(1)
          postfix = " Bedroom"
        for i in [2..5]
          if @["agroPriceBedroom" + i + "From"]
            types.push(i)
            postfix = " Bedrooms"
        types.join(", ") + postfix
  displayBuildingPrice: (queryBtype) ->
    fieldName = "agroPrice" + (if queryBtype then queryBtype.charAt(0).toUpperCase() + queryBtype.slice(1) else "Total")
    fieldNameFrom = fieldName + "From"
    fieldNameTo = fieldName + "To"
    if @[fieldNameFrom]
      "$" + accounting.formatNumber(@[fieldNameFrom]) + (if @[fieldNameFrom] is @[fieldNameTo] then "" else "+")
  buildingUnits: (limit) ->
    options = {sort: {createdAt: -1, _id: 1}}
    if limit
      options.limit = limit
    Buildings.find({parentId: @_id}, options)
  parent: ->
    Buildings.findOne(@parentId)  if @parentId
  prices: ->
    prices = []
    for key, value of btypes
      fieldName = "agroPrice" + key.charAt(0).toUpperCase() + key.slice(1)
      fieldNameFrom = fieldName + "From"
      fieldNameTo = fieldName + "To"
      if @[fieldNameFrom]
        prices.push
          price: formatPriceDisplay(@[fieldNameFrom], @[fieldNameTo])
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
