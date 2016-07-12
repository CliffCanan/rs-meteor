@addQueryFilter = (query, selector, userId, skip = {}) ->
  fieldName = "agroPriceTotalFrom"

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
        selector.$or = [
          {title: regexSearch}
          {mlsNo: regexSearch}
          {adminAvailability: regexSearch}
          {adminEscorted: regexSearch}
          {adminAppFee: regexSearch}
          {adminAvailability: regexSearch}
          {adminScheduling: regexSearch}
          {adminContact: regexSearch}
          {adminNotes: regexSearch}
        ]
      else
        # CC (1/30/16): This was only checking the "title", adding a check for address too.
        selector.title
        selector.$or = [
          {title: regexSearch}
          {address: regexSearch}
        ]

  boolFieldNames = ["fitnessCenter", "security", "laundry", "parking", "pets", "utilities"]

  for boolFieldName in boolFieldNames
    if query[boolFieldName]
      selector[boolFieldName] = {$gt: 0}

  if query.available
    available = new Date(decodeURIComponent(query.available))
    if available.getTime()
      selector.$or = [{availableAt: {$exists: false}}, {availableAt: {$lte: available}}]

  switch query.listingType
    when 'broker' then selector['source.source'] = 'IDX'
    when 'managed' then selector['source.source'] = {$ne: 'IDX'}
    # when 'all' then do nothing

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
