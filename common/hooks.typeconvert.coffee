integerFields = [
  "pets"
  "parking"
  "laundry"
  "security"
  "utilities"
  "fitnessCenter"
]

deltaFields = ["price", "sqft", "bedrooms", "bathrooms"]
for btype in btypesIds
  deltaFields.push("price" + btype.charAt(0).toUpperCase() + btype.slice(1))

dateFields = ["availableAt"]

boolFields = ["isFurnished"]

idFields = ["parentId", "adminSameId"]

buildingBeforeSave = (modifier) ->
  if modifier.features and not _.isArray(modifier.features)
    features = []
    if typeof modifier.features is "string"
      for feature in modifier.features.split(",")
        feature = feature.trim()
        features.push(feature)  if feature
    modifier.features = features
  for integerField in integerFields
    if modifier[integerField]?
      modifier[integerField] = share.intval(modifier[integerField])
  for priceField in deltaFields
    for postfix in ["From", "To"]
      fieldName = priceField + postfix
      if modifier[fieldName]?
        modifier[fieldName] = share.intval(modifier[fieldName])
  for dateField in dateFields
    if modifier[dateField]?
      modifier[dateField] = new Date(modifier[dateField])

Buildings.before.insert (userId, building) ->
  buildingBeforeSave(building)
  for deltaField in deltaFields
    for postfix in ["From", "To"]
      unless building[deltaField + postfix] > 0
        delete building[deltaField + postfix]

  for deltaField in deltaFields
    if building[deltaField + "To"]
      if not building[deltaField + "From"]
        delete building[deltaField + "To"]
      else if building[deltaField + "From"] > building[deltaField + "To"]
        building[deltaField + "To"] = building[deltaField + "From"]

  for boolField in boolFields
    if building[boolField]?
      building[boolField] = !!building[boolField]

  for idField in idFields
    if building[idField] is ""
      delete building[idField]
    else
      building[idField] = "" + building[idField]

  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  buildingBeforeSave(modifier.$set)

  modifier.$unset = modifier.$unset or {}
  for deltaField in deltaFields
    from = if modifier.$set[deltaField + "From"]? then modifier.$set[deltaField + "From"] else building[deltaField + "From"]
    to = if modifier.$set[deltaField + "To"]? then modifier.$set[deltaField + "To"] else building[deltaField + "To"]
    unless from > 0
      for postfix in ["From", "To"]
        delete modifier.$set[deltaField + postfix]
        modifier.$unset[deltaField + postfix] = true
    else unless to > 0
      delete modifier.$set[deltaField + "To"]
      modifier.$unset[deltaField + "To"] = true
    else if to < from
      delete modifier.$unset[deltaField + "To"]
      modifier.$set[deltaField + "To"] = from

  for boolField in boolFields
    if modifier.$set[boolField]?
      if modifier.$set[boolField] is ""
        delete modifier.$set[boolField]
        modifier.$unset[boolField] = true
      else
        building[boolField] = !!building[boolField]

  for idField in idFields
    if modifier.$set[idField]?
      if modifier.$set[idField] is ""
        delete modifier.$set[idField]
        modifier.$unset[idField] = true
      else
        modifier.$set[idField] = "" + modifier.$set[idField]

  unless Object.keys(modifier.$set).length
    delete modifier.$set
  unless Object.keys(modifier.$unset).length
    delete modifier.$unset

  true
