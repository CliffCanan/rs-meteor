Template.building.helpers
  helper: ->
    return ""
  hasPetsInfo: ->
    if typeof @pets.value is "number"
      return @pets.value isnt 0
    else
      return @pets.value isnt "0"
  petsAllow: ->
    if @pets
      return petsAllowance[@pets.value]
  petsComment: ->
    if @pets
      return @pets.comment
  hasPetsComment: ->
    return @pets?.comment
  arePetsAllowed: ->
    @pets.value isnt "3" or 3
  units: ->
    units = []
    if @studio
      unit = {}
      unit.type = "Studio"
      unit.price = @studio.from
      units.push(unit)
    if @bedroom1
      unit = {}
      unit.type = "1 Bedroom"
      unit.price = @bedroom1.from
      units.push(unit)
    if @bedroom2
      unit = {}
      unit.type = "2 Bedrooms"
      unit.price = @bedroom2.from
      units.push(unit)
    if @bedroom3
      unit = {}
      unit.type = "3 Bedrooms"
      unit.price = @bedroom3.from
      units.push(unit)
    if @bedroom4
      unit = {}
      unit.type = "4 Bedrooms"
      unit.price = @bedroom4.from
      units.push(unit)
    return units

  hasParkingInfo: ->
    if typeof @parking.value is "number"
      return @parking.value isnt 0
    else
      return @parking.value isnt "0"
  hasParkingComment: ->
    return @parking?.comment
  isParkingAllowed: ->
    if typeof @parking.value is "number"
      return @parking.value isnt 3
    else
      return @parking.value isnt "3"
  parkingAllow: ->
    if @parking
      return parkingAvailability[@parking.value]
  parkingComment: ->
    return @parking?.comment
  isFurnished: ->
    if @furnished
      return @furnished is "Y"
  hasHeatingAndCooling: ->
    if @heatingAndCooling
      return @heatingAndCooling is "Y"

  hasLaundryInfo: ->
    if typeof @laundry.value is "number"
      return @laundry.value isnt 0
    else
      return @laundry.value isnt "0"
  hasLaundryComment: ->
    return @laundry?.comment
  isLaundryAllowed: ->
    if typeof @laundry.value is "number"
      return @laundry.value isnt 3
    else
      return @laundry.value isnt "3"
  laundryAllow: ->
    if @laundry
      return laundryAvailability[@laundry.value]
  laundryComment: ->
    return @laundry?.comment    



Template.building.rendered = ->
  addthis.init()

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('show')

petsAllowance =["Unknown","Pets Allowed", "Pets Allowed", "Pets Not Allowed"]
parkingAvailability =["Unknown", "Included", "Available", "No Parking"]
laundryAvailability =["Unknown","In-unit Laundry", "On-site Laundry", "No Laundry"]
