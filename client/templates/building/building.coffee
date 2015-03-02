Template.building.helpers
  featureRows: ->
    featureRows = []
    if @features
      for feature in @features
        if not lastRow or lastRow.length >= 4
          lastRow = []
          featureRows.push(lastRow)
        lastRow.push(feature)
    if featureRows.length is 0
      parent = @parent()
      if parent
        if parent.features
          for feature in parent.features
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

  isFurnished: ->
    if @furnished
      return @furnished is "Y"

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
    if $firstItem.length
      $firstItem.addClass("active")
      $carousel.show().carousel()
    else
      $carousel.hide()
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


