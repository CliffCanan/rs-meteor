@addQueryFilter = (query, selector) ->
  fieldName = "agroPriceTotalFrom"
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
    selector.title = createTextSearchRegexp(decodeURIComponent(query.q))
  boolFieldNames = ["fitnessCenter", "security", "laundry", "parking", "pets", "utilities"]
  for boolFieldName in boolFieldNames
    if query[boolFieldName]
      selector[boolFieldName] = {$gt: 0}
  if query.available
    available = new Date(decodeURIComponent(query.available))
    if available.getTime()
      selector.$or = [{availableAt: {$exists: false}}, {availableAt: {$lte: available}}]
      