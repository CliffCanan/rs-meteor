Template.building.helpers
  hasPetsInfo: ->
    if @pets and @pets.value
      if typeof @pets.value is "number"
        return @pets.value isnt 0
      else
        return @pets.value isnt "0"
    else
      return false
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
  featureRows: ->
    featureRows = []
    for feature in @features
      if not lastRow or lastRow.length >= 4
        lastRow = []
        featureRows.push(lastRow)
      lastRow.push(feature)
    featureRows
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
    units

  hasParkingInfo: ->
    if @parking and @parking.value
      if typeof @parking.value is "number"
        return @parking.value isnt 0
      else
        return @parking.value isnt "0"
    else
      return false
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
    if @laundry and @laundry.value
      if typeof @laundry.value is "number"
        return @laundry.value isnt 0
      else
        return @laundry.value isnt "0"
    else
      return false
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

  hasSecurityInfo: ->
    if @security and @security.value
      if typeof @security.value is "number"
        return @security.value isnt 0
      else
        return @security.value isnt "0"
    else
      return false
  hasSecurityComment: ->
    return @security?.comment
  isSecurityAllowed: ->
    if typeof @security?.value is "number"
      return @security.value isnt 3
    else
      return @security.value isnt "3"
  securityAllow: ->
    if @security
      return securityAvailability[@security.value]
  securityComment: ->
    return @security?.comment

  hasUtilitiesInfo: ->
    if @utilities and @utilities.value
      if typeof @utilities.value is "number"
        return @utilities.value isnt 0
      else
        return @utilities.value isnt "0"
    else
      return false
  hasUtilitiesComment: ->
    return @utilities?.comment
  isUtilitiesAllowed: ->
    if typeof @utilities?.value is "number"
      return @utilities.value isnt 3
    else
      return @utilities.value isnt "3"
  utilitiesAllow: ->
    if @utilities
      return utilitiesAvailability[@utilities.value]
  utilitiesComment: ->
    return @utilities?.comment
    
  hasFitnessCenterInfo: ->
    if @fitnessCenter and @fitnessCenter.value
      if typeof @fitnessCenter.value is "number"
        return @fitnessCenter.value isnt 0
      else
        return @fitnessCenter.value isnt "0"
    else
      return false
  hasFitnessCenterComment: ->
    return @fitnessCenter?.comment
  isFitnessCenterAllowed: ->
    if typeof @fitnessCenter?.value is "number"
      return @fitnessCenter.value isnt 3
    else
      return @fitnessCenter.value isnt "3"
  fitnessCenterAllow: ->
    if @fitnessCenter
      return fitnessCenterAvailability[@fitnessCenter.value]
  fitnessCenterComment: ->
    return @fitnessCenter?.comment

  getBuildingData: ->
    cityId: @cityId
    neighborhoodSlug: @neighborhoodSlug
    buildingSlug: @slug
    
  hasParent: ->
    return @parentId and @parentId isnt '' and @parentId isnt '0'
  parentNeighborhoodSlug: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.neighborhoodSlug
  parentSlug: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.slug
  parentName: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.name
  ironRouterHack: ->
    Router.current() # reactivity
    addthis?.init()
    $carousel = $(".carousel")
    carousel = $carousel.data("bs.carousel")
    if carousel
      carousel.pause()
      carousel.destroy()
    $firstItem = $carousel.find(".item:first")
    $firstItem.addClass("active")
    $carousel.carousel()
    return ""

  showAllBuildingUnits: ->
    Session.get("showAllBuildingUnits")
  buildingUnitsArray: ->
    array = []
    i = 0
    for unit in @buildingUnits().fetch()
      array.push(
        {
          index: i++
          unit: [unit]
        }
      )
    array

Template.building.rendered = ->
  Session.set("showAllBuildingUnits", false)

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    $('#checkAvailabilityPopup').modal('show')

  "click .unit-check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    $('#checkAvailabilityPopup').modal('show')

  "click .building-unit-item-more": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", true)

  "click .building-unit-item-less": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", false)

petsAllowance =["Unknown","Pets Allowed", "Pets Allowed", "Pets Not Allowed"]
parkingAvailability =["Unknown", "Parking Included", "Parking Available", "No Parking"]
laundryAvailability =["Unknown","In-unit Laundry", "On-site Laundry", "No Laundry"]
securityAvailability =["Unknown","Doorman", "No Doorman"]
utilitiesAvailability = ["Unknown","Utilities Included", "Utilities Extra Charge"]
fitnessCenterAvailability = ["Unknown","Fitness Center", "No Fitness Center"]
