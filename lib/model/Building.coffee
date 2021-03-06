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
        price += " - $" + accounting.formatNumber(to)
    else
      price += "+"
  price

getCurrentClientUnit = (parentId) ->
  clientObject = Session.get "recommendationsClientObject"
  if clientObject
    clientId = clientObject.clientId
    clientRecommendations = ClientRecommendations.findOne clientId
    if clientRecommendations
      unitObject = clientRecommendations.findUnitByParent parentId
      if unitObject
        unitId = unitObject.unitId
        return unit = Buildings.findOne unitId
  null

getPriceRange = (building, type) ->
  fieldName = "agroPrice" + (if type then type.charAt(0).toUpperCase() + type.slice(1) else "Total")
  fieldNameFrom = fieldName + "From"
  fieldNameTo = fieldName + "To"

  from: building[fieldNameFrom]
  to: building[fieldNameTo]

class Building
  constructor: (doc) ->
    _.extend(@, doc)
  cityName: ->
    cities[@cityId].short

  processedTitle: ->
    if Session.get "showRecommendations"
      building = getCurrentClientUnit(@_id)
      return @getUnitTitle.call building if building
    return @title

  getRouteData: ->
    data =
      cityId: @cityId
      neighborhoodSlug: @neighborhoodSlug
      buildingSlug: @slug
    if parent = @parent()
      data.buildingSlug = parent.slug
      data.unitSlug = @slug
    data

  processedRouteData: ->
    if Session.get "showRecommendations"
      building = getCurrentClientUnit(@_id)
      return @getRouteData.call building if building
    return @getRouteData()

  mainImage: ->
    file = @getImages()?[0]
    file  if file?.url

  getImages: ->
    if @images?.length
      @images
    else
      @parent()?.images

  getMedia: ->
    if @images?.length
      @images.map (item, index) ->
        item._index = index + 1
        item
    else
      @parent()?.images

  getVideo: ->
    @vimeoId

  getDescription: ->
    @description ? @parent()?.description

  getSqft: ->
    if @sqftFrom
      sqft = @sqftFrom
      if @sqftTo
        if @sqftFrom isnt @sqftTo
          sqft += "-" + @sqftTo
      else
        sqft += "+"
      sqft

  getFeatures: ->
    # Filter out 'Tenant Pays..' features to comply with TrendMLS requirements
    if @source and @source.source is 'IDX'
      if @features
        _.reject @features, (feature) ->
          (feature.indexOf 'Tenant Pays') > -1
      else
        []
    else
      if @features?.length then @features else @parent()?.features

  getAvailableAt: ->
    if @availableAt > new Date()
      @availableAt

  getAvailableAtDate: ->
    moment(@availableAt).format("MM/DD/YYYY")

  canApply: ->
    if @agroIsUnit and @availableAt and @acceptOnlineApplication
      if moment().diff(moment(@availableAt), 'months') < 4
        return true
    false

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
      if @bathroomsTo and @bathroomsFrom is not @bathroomsTo
        value += " - " + @bathroomsTo
      value += " BA"
#      if @bathroomsTo > 1
#        value += "s"
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
    if Session.get "showRecommendations"
      unit = getCurrentClientUnit(@_id)
      if unit
        return btypes[unit.btype]?.upper if unit.btype

    if queryBtype
      if queryBtype is "studio" or queryBtype is "bedroom0"
        "Studio"
      else
        btypesIds.indexOf(queryBtype) + " BR"
    else
      if @agroIsUnit
        btypes[@btype]?.upper.replace("room", "")
      else
        types = []
        postfix = ""

        if @agroPriceStudioFrom
          types.push("Studio")

        for i in [0..5]
          if @["agroPriceBedroom" + i + "From"]
            types.push(i)
        types.join(", ")# + " BR"

  bedroomTypesArray: ->
    types = []
    if @agroPriceStudioFrom or @agroPriceBedroom0From
      types.push("Studio")
    for i in [0..5]
      if @["agroPriceBedroom" + i + "From"]
        types.push("#{i} Bedroom")
    types

  getPriceRange: (type) ->
    getPriceRange @, type

  displayBuildingPrice: (queryBtype) ->
    if Session.get "showRecommendations"
      unit = getCurrentClientUnit(@_id)
      if unit
        return formatPriceDisplay unit.priceFrom, unit.priceTo if unit.priceFrom

    range = getPriceRange @, queryBtype
    if range.from
      "$" + accounting.formatNumber(range.from) + (if range.from is range.to then "" else "+")

  buildingUnits: (limit) ->
    options = {sort: {createdAt: -1, _id: 1}}
    if limit
      options.limit = limit
    Buildings.find({parentId: @_id}, options)

  buildingUnitsCount: ->
    Buildings.find({parentId: @_id}).count()

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

  metaTags: ->
    bedrooms = @bedroomTypesArray()
    city = cities[@cityId].short
    neighborhood = if @neighborhood then @neighborhood else ""
    prefix = ''
    suffix = ''
    if bedrooms.length
      if bedrooms.length is 1
        prefix = "#{bedrooms[0]} Apartment "
      else
        suffix = " Apartment Rentals in"

    title = "#{prefix}#{@title}#{suffix}, #{{neighborhood}} | #{city}"
    if title.length > 64
      title = title.substring(0, 65)

    features = []
    featuresPrefix = ''
    featuresSummary = ''

    for fieldName in ["fitnessCenter", "laundry", "security", "utilities", "parking"]
      value = @[fieldName]
      if value
        features.push complexFieldsValues[fieldName].values[value].toLowerCase() if value is 1

    if features.length
      featuresPrefix = " with "
      featuresSummary = features.join(", ")

    description = "Currently available #{@bedroomTypes()} BR apartments#{featuresPrefix}#{featuresSummary}. View photos videos, maps and floorplans of units at #{@title} in #{@neighborhood}, #{city}"

    if bedrooms.length and bedrooms.length is 1
      availableAt = moment(@availableAt)
      availableDate = availableAt.format('d MMMM')
      sqft = if @getSqft() then "#{@getSqft()} sq ft" else ''
      if featuresSummary
        featuresSummary = "Includes #{featuresSummary}"
        if sqft
          sqft = ", #{sqft}"
      if sqft or featuresSummary then endPeriod = '. ' else endPeriod = ''
      description = "#{@displayBuildingPrice()} #{bedrooms[0]} apartment available #{availableDate} at #{@title}. #{featuresSummary}#{sqft}#{endPeriod}View photos videos, maps and floorplans of units in #{@neighborhood}, #{city}"

    title: title
    description: description


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
