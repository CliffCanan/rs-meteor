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
      # If Admin, search query should also look in admin fields
      if userId and Security.canOperateWithBuilding(userId)
        regexSearch = createTextSearchRegexp(decodeURIComponent(query.q))
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
        selector.title = createTextSearchRegexp(decodeURIComponent(query.q))
  boolFieldNames = ["fitnessCenter", "security", "laundry", "parking", "pets", "utilities"]
  for boolFieldName in boolFieldNames
    if query[boolFieldName]
      selector[boolFieldName] = {$gt: 0}
  if query.available
    available = new Date(decodeURIComponent(query.available))
    if available.getTime()
      selector.$or = [{availableAt: {$exists: false}}, {availableAt: {$lte: available}}]