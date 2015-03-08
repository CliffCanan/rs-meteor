positions = [10000, 5000, 0, -5000, -10000]

Template.building.helpers
  ironRouterHack: ->
    Router.current() # reactivity
    editBuildingId = Session.get("editBuildingId")
    _.defer ->
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

  isEdit: ->
    Session.equals("editBuildingId", @_id)

  isManualPosition: ->
    @position not in positions

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

  adminBuilding: ->
    if @adminSameId then Buildings.findOne(@adminSameId) else @

Template.building.rendered = ->
  Session.set("showAllBuildingUnits", false)
  setHeights()
  building = @data.building
  cityData = cities[building.cityId]
  map = new google.maps.Map document.getElementById("gmap"),
    zoom: 14
    center: new google.maps.LatLng(cityData.latitude, cityData.longitude)
    streetViewControl: false
    scaleControl: false
    rotateControl: false
    panControl: false
    overviewMapControl: false
    mapTypeControl: false
    mapTypeId: google.maps.MapTypeId.ROADMAP
  @map = map
  infowindow = new google.maps.InfoWindow()
  defaultIcon = new google.maps.MarkerImage("/images/map-marker.png", null, null, null, new google.maps.Size(34, 40))
  activeIcon = new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null,
    new google.maps.Size(50, 60))
  if building.latitude and building.longitude
    marker = new google.maps.Marker
      _id: building._id
      title: building.title
      position: new google.maps.LatLng(building.latitude, building.longitude)
      map: map
      icon: defaultIcon

    google.maps.event.addListener marker, "click", do (marker, building) ->->
      mixpanel.track("property-container-map")
      html = Blaze.toHTMLWithData(Template.buildingMarker, building)
      infowindow.setContent(html)
      infowindow.open(map, marker)
      infoWindowId = marker._id
      marker.setIcon(activeIcon)

      google.maps.event.addListener infowindow, "closeclick", ->
        marker.setIcon(defaultIcon)

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
    Session.set("imageToRemove", null)

  "change .choose-image-input": grab encapsulate (event, template) ->
    buildingId = @_id
    FS.Utility.eachFile(event, (file) ->
      inserted = BuildingImages.insert(file)
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

  "click .remove-building": grab encapsulate (event, template) ->
    $("#confirmBuildingRemoval").modal("show")

  "click .confirm-building-removal": grab encapsulate (event, template) ->
    building = template.data.building
    Buildings.remove(building._id)
    parent = building.parent()
    if parent
      Router.go("building", parent.getRouteData())
    else
      Router.go("city", {cityId: building.cityId})
    $("#confirmBuildingRemoval").modal("hide")

  "click .edit-building": (event, template) ->
    Session.set("editBuildingId", template.data.building._id)

  "submit .building-form": (event, template) ->
    event.preventDefault()
    $form = $(event.currentTarget)
    data = $form.serializeJSON({parseAll: true, checkboxUncheckedValue: false})
    if Object.keys(data).length
      building = Buildings.findOne(template.data.building._id)
      $form.find(".submit-button").prop("disabled", true)
      $form.find(".loading").show()
      Meteor.apply "updateBuilding", [building._id, data], onResultReceived: (error, newUrl) ->
        unless error
          Session.set("editBuildingId", null)
          if newUrl isnt Router.routes["building"].path(building.getRouteData())
            Router.go(newUrl)
        $form.find(".submit-button").prop("disabled", false)
        $form.find(".loading").hide()
    else
      Session.set("editBuildingId", null)

  "click .publish-building-toggle": (event, template) ->
    building = template.data.building
    Buildings.update(building._id, {$set: {isPublished: !building.isPublished}})

  "change .select-position-defs": (event, template) ->
    $select = $(event.currentTarget)
    $input = $(".input-building-postion")
    value = $select.val()
    if value is "manual"
      $input.removeClass("hidden")
    else
      $input.val(value).addClass("hidden")


updateBuilding = (buildingId, newObject, item) ->
  Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}})
  item.find(".loading").hide()
