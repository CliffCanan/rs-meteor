Template.building.helpers
  admin: ->
    Meteor.user().role is "admin"
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

  "click .remove-image": grab encapsulate (event, template) ->
    Session.set("imageToRemove", @_id)
    $('#confirmRemoval').modal('show')

  "click .confirm-removal":  grab encapsulate (event, template) ->
    Buildings.update({ _id: template.data.building._id}, { $pull: { images: {"EJSON$value.EJSON_id": Session.get("imageToRemove") }} })
    $('#confirmRemoval').modal('hide')
    Session.get("imageToRemove", null)

  "change .choose-image-input": grab encapsulate (event, template) ->
    buildingId = @_id
    FS.Utility.eachFile(event, (file) ->
      inserted = BuildingImages.insert(file)
      cl $(template)
      cl template
      item = @$(".add-image-item")
      item.find(".loading").show()
      newObject = {}
      newObject.EJSON$type = "FS.File"
      newObject.EJSON$value = {}
      newObject.EJSON$value.EJSON_id = inserted._id
      newObject.EJSON$value.EJSONcollectionName = "images"

      Meteor.setTimeout(() ->
        updateBuilding(buildingId, newObject, item)
      , 5000)
    )

updateBuilding = (buildingId, newObject, item) ->
  Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}})
  item.find(".loading").hide()