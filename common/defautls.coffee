integerFields = [
  "pets"
  "parking"
  "laundry"
  "security"
  "utilities"
  "fitnessCenter"
]

pricesFields = ["price"]
for btype in btypesIds
  pricesFields.push("price" + btype.charAt(0).toUpperCase() + btype.slice(1))

buildingBeforeSave = (modifier) ->
  for integerField in integerFields
    if modifier[integerField]?
      modifier[integerField] = share.intval(modifier[integerField])
  for priceField in pricesFields
    for postfix in ["From", "To"]
      fieldName = priceField + postfix
      if modifier[fieldName]?
        modifier[fieldName] = share.intval(modifier[fieldName])

Buildings.before.insert (userId, building) ->
  buildingBeforeSave(building)
  for pricesField in pricesFields
    for postfix in ["From", "To"]
      unless building[pricesField + postfix] > 0
        delete building[pricesField + postfix]

  for pricesField in pricesFields
    if building[pricesField + "To"]
      if not building[pricesField + "From"]
        delete building[pricesField + "To"]
      else if building[pricesField + "From"] > building[pricesField + "To"]
        building[pricesField + "To"] = building[pricesField + "From"]

  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  buildingBeforeSave(modifier.$set)

  modifier.$unset = modifier.$unset or {}
  for pricesField in pricesFields
    from = if modifier.$set[pricesField + "From"]? then modifier.$set[pricesField + "From"] else building[pricesField + "From"]
    to = if modifier.$set[pricesField + "To"]? then modifier.$set[pricesField + "To"] else building[pricesField + "To"]
    unless from > 0
      for postfix in ["From", "To"]
        delete modifier.$set[pricesField + postfix]
        modifier.$unset[pricesField + postfix] = true
    else unless to > 0
      delete modifier.$set[pricesField + "To"]
      modifier.$unset[pricesField + "To"] = true
    else if to < from
      delete modifier.$unset[pricesField + "To"]
      modifier.$set[pricesField + "To"] = from

  true
