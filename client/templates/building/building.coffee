Template.building.helpers
  isFurnished: ->
    if @furnished
      return @furnished is "Y"

  ironRouterHack: ->
    Router.current() # reactivity
    $('[data-toggle="tooltip"]').tooltip()
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
  buildingUnitsLimited: ->
    if Session.get("showAllBuildingUnits")
      @buildingUnits()
    else
      @buildingUnits(2)

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

  "click .edit-building": (event, template) ->
    Session.set("editBuildingId", template.data.building._id)

  "submit .building-form": (event, template) ->
    event.preventDefault()
    data = $(event.currentTarget).serializeFormJSON()
    if Object.keys(data).length
      building = Buildings.findOne(template.data.building._id)
      Meteor.apply "updateBuilding", [building._id, data], onResultReceived: (error, slug) ->
        unless error
          if building.slug isnt slug
            building.slug = slug
            Router.go("building", building.getRouteData())
          else
            Session.set("editBuildingId", false)
    else
      Session.set("editBuildingId", false)
