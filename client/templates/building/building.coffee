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

  userCheck: ->
    if Meteor.user()
      review = UserReviews.find({building: @_id, userId: Meteor.userId()})
      if review.count() > 0
        return false
      else 
        return true
    else
      return false

  bulidingReviews: ->
    UserReviews.find({building: @_id})

  isManualPosition: ->
    @position not in positions

  similarProperties: (building) ->
    from = building.agroPriceTotalTo - 200
    to = building.agroPriceTotalTo + 200
    selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}  
    Buildings.find(selector, {limit: 4})

  buildingUnitsLimited: ->
    if Session.get("showAllBuildingUnits")
      @buildingUnits()
    else
      @buildingUnits(4)
  displayBuildingPrice: (queryBtype) ->
    fieldName = "agroPrice" + (if queryBtype then queryBtype.charAt(0).toUpperCase() + queryBtype.slice(1) else "Total")
    fieldNameFrom = fieldName + "From"
    fieldNameTo = fieldName + "To"
    if @[fieldNameFrom]
      "$" + accounting.formatNumber(@[fieldNameFrom]) + (if @[fieldNameFrom] is @[fieldNameTo] then "" else "+")
  bedroomTypes: (queryBtype) ->
    if queryBtype
      if queryBtype is "studio"
        "Studio"
      else if queryBtype is "bedroom1"
        "1 Bedroom"
      else
        btypesIds.indexOf(queryBtype) + " Bedrooms"
    else
      if @agroIsUnit
        btypes[@btype]?.upper.replace("room", "")
      else
        types = []
        postfix = ""
        if @agroPriceStudioFrom
          types.push("Studio")
        if @agroPriceBedroom1From
          types.push(1)
          postfix = " Bedroom"
        for i in [2..5]
          if @["agroPriceBedroom" + i + "From"]
            types.push(i)
            postfix = " Bedrooms"
        types.join(", ") + postfix

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
    if parent = @parent()
      if parent.adminSameId then Buildings.findOne(parent.adminSameId) else parent
    else
      if @adminSameId then Buildings.findOne(@adminSameId) else @

Template.building.rendered = ->
  Session.set("showAllBuildingUnits", false)
  setHeights()
  building = @data.building
  cityData = cities[building.cityId]

  directionsDisplay = new google.maps.DirectionsRenderer();
  directionsService = new google.maps.DirectionsService()
  map = ""

  map = new google.maps.Map document.getElementById("gmap"),
    zoom: 16
    center: new google.maps.LatLng(cityData.latitude, cityData.longitude)
    streetViewControl: false
    scaleControl: false
    rotateControl: false
    panControl: false
    overviewMapControl: false
    mapTypeControl: false
    mapTypeId: google.maps.MapTypeId.ROADMAP
  @map = map
  directionsDisplay.setMap(map)
  #if building.isOnMap and building.latitude and building.longitude


  if building.latitude and building.longitude
    latLng = new google.maps.LatLng(building.latitude, building.longitude)
    map.setCenter(latLng)
    marker = new google.maps.Marker
      _id: building._id
      title: building.title
      position: latLng
      map: map
      icon: new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null, new google.maps.Size(50, 60))

    @autorun ->
      buildingReactive = Buildings.findOne(building._id, {fields: {latitude: 1, longitude: 1}})
      latLng = new google.maps.LatLng(buildingReactive.latitude, buildingReactive.longitude)
      marker.setPosition(latLng)
      map.setCenter(latLng)

  if Session.get("address")
    address = Session.get("address")
    marker = new google.maps.Marker
      title: Session.get("addressName")
      position: new google.maps.LatLng(address[0], address[1])
      map: map
      icon: new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null, new google.maps.Size(50, 60))

    calcRoute(building.cityId, Session.get("addressName"), directionsService, directionsDisplay)
  $ ->
    $('#new-review').autosize append: '\n'
    reviewBox = $('#post-review-box')
    newReview = $('#new-review')
    openReviewBtn = $('#open-review-box')
    closeReviewBtn = $('#close-review-box')
    ratingsField = $('#ratings-hidden')
    openReviewBtn.click (e) ->
      reviewBox.slideDown 400, ->
        $('#new-review').trigger 'autosize.resize'
        newReview.focus()
        return
      openReviewBtn.fadeOut 100
      closeReviewBtn.show()
      return
    closeReviewBtn.click (e) ->
      e.preventDefault()
      reviewBox.slideUp 300, ->
        newReview.focus()
        openReviewBtn.fadeIn 200
        return
      closeReviewBtn.hide()
      return
    $('.starrr').on 'starrr:change', (e, value) ->
      ratingsField.val value
      return
    return

# ---
# generated by js2coffee 2.0.3    

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

  "click #saveReview": grab encapsulate (event, template) ->
    event.preventDefault()
    review = $("#new-review").val()
    Meteor.apply "insertReviews", [review, @_id], onResultReceived: (error, result) ->
      unless error
        console.log result

    #UserReviews.insert({userId: "aaa", reviews: "bbbb"})
    #Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}})

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

  "click .cancel-building": (event, template) ->
    Session.set("editBuildingId", null)

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

  "click .add-unit": (event, template) ->
    Meteor.apply "addUnit", [template.data.building._id], onResultReceived: (error, result) ->
      unless error
        Session.set("editBuildingId", result.buildingId)
        Router.go(result.url)

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

calcRoute = (from, to, directionsService, directionsDisplay) ->
  

  request = 
    origin: from
    destination: to
    travelMode: google.maps.TravelMode.DRIVING  

  directionsService.route request, (result, status) ->
    console.log status
    if status == google.maps.DirectionsStatus.OK
      directionsDisplay.setDirections result    
