generatePriceFilter = (building) ->
  prices = []
  for type in btypesIds
    fieldName = "price" + type.charAt(0).toUpperCase() + type.slice(1)
    for postfix in ["From", "To"]
      value = building[fieldName + postfix]
      if value
        prices.push(value)
  if prices.length
    Buildings.direct.update {_id: building._id},
      $set:
        agroPriceTotalFrom: Math.min.apply(null, prices)
        agroPriceTotalTo: Math.max.apply(null, prices)
  else
    Buildings.direct.update({_id: building._id}, {$unset: {agroPriceTotalFrom: 1, agroPriceTotalTo: 1}})

Buildings.after.insert (userId, building) ->
  generatePriceFilter(building)

Buildings.after.update (userId, building, fieldNames, modifier, options) ->
  generatePriceFilter(building)
