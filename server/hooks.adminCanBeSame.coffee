adminFields = [
  "adminAvailability"
  "adminEscorted"
  "adminAppFee"
  "adminOfficeHours"
  "adminScheduling"
  "adminContact"
  "adminNotes"
]

buildingCanBeSame = (building) ->
  agroCanBeSame = false
  unless @parentId
    for fieldName in adminFields
      if building[fieldName]
        agroCanBeSame = true
        break
  agroCanBeSame

Buildings.before.insert (userId, building) ->
  building.agroCanBeSame = buildingCanBeSame(building)

  true

Buildings.after.update (userId, building, fieldNames, modifier, options) ->
  agroCanBeSame = buildingCanBeSame(building)

  if @previous.agroCanBeSame isnt agroCanBeSame
    Buildings.direct.update({_id: building._id}, {$set: {agroCanBeSame: agroCanBeSame}})
#    unless agroCanBeSame
#      Buildings.direct.update({adminSameId: building._id}, {$unset: {adminSameId: true}}, {multi: true})
