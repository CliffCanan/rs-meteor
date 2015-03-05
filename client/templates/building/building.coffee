Template.building.helpers
  admin: ->
    Meteor.user()?.role is "admin"

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

  btypesFields: (building) ->
    for key, btype of btypes
      root = key.charAt(0).toUpperCase() + key.slice(1)
      nameFrom = "price" + root + "From"
      nameTo = "price" + root + "To"
      type: btype.upper
      nameFrom: nameFrom
      nameTo: nameTo
      valueFrom: building[nameFrom]
      valueTo: building[nameTo]

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

  "click .edit-building": (event, template) ->
    Session.set("editBuildingMode", true)

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
            Session.set("editBuildingMode", false)
    else
      Session.set("editBuildingMode", false)

updateBuilding = (buildingId, newObject, item) ->
  Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}})
  item.find(".loading").hide()
