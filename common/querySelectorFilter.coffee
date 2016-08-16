@addQueryFilter = (query, selector, userId, skip = {}) ->
  fieldName = "agroPriceTotalFrom"

  andStatements = []

  if query._id
    selector._id = query._id

  if not query['unpublished']
    selector.isPublished = true

  if query.neighborhoodSlug
    selector.neighborhoodSlug = query.neighborhoodSlug

  if query.btype
    fieldName = "agroPrice" + query.btype.charAt(0).toUpperCase() + query.btype.slice(1) + "From"
    selector[fieldName] = {$exists: true}
  priceFrom = parseInt(query.from)
  priceTo = parseInt(query.to)

  if priceFrom or priceTo
    selector[fieldName] = selector[fieldName] or {}
    if priceFrom
      selector[fieldName].$gte = priceFrom
    if priceTo
      selector[fieldName].$lte = priceTo

  if query.q
    unless skip.q
      regexSearch = createTextSearchRegexp(decodeURIComponent(query.q))
      
      # If Admin, search query should also look in admin fields
      if userId and Security.canOperateWithBuilding(userId)
        andStatements.push {$or: [
          {title: regexSearch}
          {address: regexSearch}
          {mlsNo: regexSearch}
          {adminAvailability: regexSearch}
          {adminEscorted: regexSearch}
          {adminAppFee: regexSearch}
          {adminAvailability: regexSearch}
          {adminScheduling: regexSearch}
          {adminContact: regexSearch}
          {adminNotes: regexSearch}
        ]}
      else
        # CC (1/30/16): This was only checking the "title", adding a check for address too.
        selector.title
        andStatements.push {$or: [
          {title: regexSearch}
          {address: regexSearch}
        ]}

  # @see Building.coffee:1 (complexFieldsValues variable)
  selector.pets = {$in: [1, 2]} if query.pets
  selector.parking = {$in: [1, 2]} if query.parking
  selector.laundry = 1 if query.laundry
  selector.security = 1 if query.security
  selector.utilities = 1 if query.utilities
  selector.fitnessCenter = 1 if query.fitnessCenter

  if query.available
    available = new Date(decodeURIComponent(query.available))
    if available.getTime()
      andStatements.push {$or: [{availableAt: {$exists: false}}, {availableAt: {$lte: available}}]}

  switch query.listingType
    when 'broker' then selector['source.source'] = 'IDX'
    when 'managed' then selector['source.source'] = {$ne: 'IDX'}
    # when 'all' then do nothing

  selector.$and = andStatements if andStatements.length
  
@addMapBoundsFilter = (mapBounds, selector) ->
  if mapBounds.latitudeMin isnt mapBounds.latitudeMax
    if mapBounds.latitudeMin
      selector.latitude ?= {}
      selector.latitude.$gt = mapBounds.latitudeMin
    if mapBounds.latitudeMax
      selector.latitude ?= {}
      selector.latitude.$lt = mapBounds.latitudeMax
  if mapBounds.longitudeMin isnt mapBounds.longitudeMax
    if mapBounds.longitudeMin
      selector.longitude ?= {}
      selector.longitude.$gt = mapBounds.longitudeMin
    if mapBounds.longitudeMax
      selector.longitude ?= {}
      selector.longitude.$lt = mapBounds.longitudeMax
