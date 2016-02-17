positions = [10000, 5000, 0, -5000, -10000]

Template.building.onCreated ->
  building = Router.current().data().building

  if building.parentId
    buildingSimilarId = building.parentId
    # Subscribe to the parent building that only returns the few fields required to search for similar buildings.
    @subscribe("buildingForSimilar", buildingSimilarId)
  else
    buildingSimilarId = building._id

  @subscribe("buildingReviews", buildingSimilarId)
  @subscribe("buildingsSimilar", buildingSimilarId)


Template.building.helpers 
  ironRouterHack: ->
    Router.current() # reactivity
    editBuildingId = Session.get("editBuildingId")

    unless $.fn.imgLiquid
      $.getScript '/js/imgLiquid-min.js', ->
        $('#carousel-example-generic .item').imgLiquid
          fill: false
          verticalAlign: '50%'
        $('#carousel-example-generic .item').css('visibility', 'visible')

    _.defer ->
      $('[data-toggle="tooltip"]').tooltip()

      #addthis?.init()

      ###
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
      ###

      $('#sliderAptImgs').slick
        #mobileFirst: true
        variableWidth: true
        easing: "ease"
        speed: 500

      ###if $.fn.imgLiquid
        $('#sliderAptImgs .item').imgLiquid
          fill: false
          verticalAlign: '50%'
        $('#sliderAptImgs .item').css('visibility', 'visible')###

    return ""

  getRating: (rating) ->
    if rating == undefined
      0
    else 
      rating

  getRatingValue: (rating) ->
    parseInt(rating, 10)/10

  rentalQuery: ->
    buildingId: @_id

  isEdit: -> 
    Session.equals("editBuildingId", @_id)

  isManualPosition: ->
    @position not in positions

  similarProperties: (building) ->
    building = Buildings.findOne(building.parentId) if building.agroIsUnit and building.parentId
    from = building.agroPriceTotalTo - 300
    to = building.agroPriceTotalTo + 300
    selector = {_id: {$ne: building._id}, cityId: building.cityId, parentId: {$exists: false}, bathroomsTo: building.bathroomsTo, agroPriceTotalTo: {$gte: from}, agroPriceTotalTo : {$lte: to}}  
    Buildings.find(selector, {limit: 4})

  buildingUnitsLimited: ->
    #if Session.get("showAllBuildingUnits")
    @buildingUnits()
    #else
    #  @buildingUnits(4)

  displayBuildingPrice: (queryBtype) ->
    fieldName = "agroPrice" + (if queryBtype then queryBtype.charAt(0).toUpperCase() + queryBtype.slice(1) else "Total")
    fieldNameFrom = fieldName + "From"
    fieldNameTo = fieldName + "To"
    if @[fieldNameFrom]
      "$" + accounting.formatNumber(@[fieldNameFrom]) + (if @[fieldNameFrom] is @[fieldNameTo] then "" else " +")

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
        isMediumScreenSize = (if $(window).width() > 768 then true else false)
        types = []
        postfix = ""
        if @agroPriceStudioFrom
          types.push("Studio")
        if @agroPriceBedroom1From
          types.push(1)
          postfix = (if isMediumScreenSize then " Bedroom" else " BR")
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

  getThumbnail: (store) ->
    share.getThumbnail.call @, store

  isImage: ->
    @ instanceof FS.File

  isFirstSlide: ->
    @_index is 1

  removeMediaType: ->
    media = Session.get("imageToRemove")
    if media
      return 'image' if media instanceof FS.File
      return 'video' if media.vimeoId?

  buildingReviews: ->
    if @agroIsUnit and @parentId
      buildingId = @parentId
    else
      buildingId = @_id
    BuildingReviews.find({buildingId: buildingId, isPublished: true}, {sort: {createdAt: -1}})

  reviewFormDefaults: ->
    Session.get('reviewFormDefaults')


Template.building.onRendered ->
  instance = @

  #console.log("building.onRendered -> instance...")
  #console.log(instance)

  $('main').addClass('container')

  $('[data-toggle="popover"]').popover
    html: true
    title: 'Commute Calculator <a class="close" data-dismiss="popover" href="#">&times;</a>'
    content: Blaze.toHTMLWithData(Template.filterListingMarker, ->
      address: Session.get('enteredAddress')
      travelMode: Session.get('travelMode') or 'walking'
    )

  Session.set('travelTimes', {})

  $('[data-toggle="popover"]').each ->
    button = $(this)
    button.popover().on('shown.bs.popover', ->
      $('#address').focus()
      button.data('bs.popover').tip().find('[data-dismiss="popover"]').on('click', ->
        button.popover('toggle')
      )
    )

  @autorun ->
    if Session.get('travelTimes') or Session.get('travelMode')
      $('[data-toggle="popover"]').data('bs.popover').options.content = Blaze.toHTMLWithData Template.filterListingMarker, ->
        address: Session.get('enteredAddress')
        travelTimes: Session.get('travelTimes')
        travelMode: Session.get('travelMode')

  $(".clear-rating").remove()
  $(".rating").rating()
  $('.rating-disabled').find(".clear-rating").remove()

  Session.set("showAllBuildingUnits", false)

  setHeights()
  building = @data.building
  cityData = cities[building.cityId]
  filterIcon = new google.maps.MarkerImage("/images/map-marker-filter.png", null, null, null, new google.maps.Size(50, 60))
  filterDefaultIcon = new google.maps.MarkerImage("/images/map-marker-default.png", null, null, null, new google.maps.Size(50, 60))  
  defaultIcon = new google.maps.MarkerImage("/images/map-marker.png", null, null, null, new google.maps.Size(34, 40))   
  activeIcon = new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null, new google.maps.Size(50, 60))
  activeIcon1 = new google.maps.MarkerImage("/images/map-marker-active2.png", null, null, null, new google.maps.Size(50, 60))    
  @directionsDisplay = new google.maps.DirectionsRenderer()
  @directionsService = new google.maps.DirectionsService()

  @travelInfoWindow = new google.maps.InfoWindow()
  map = ""

  map = new google.maps.Map document.getElementById("gmap"),
    zoom: 15
    center: new google.maps.LatLng(cityData.latitude, cityData.longitude)
    streetViewControl: true
    scaleControl: false
    rotateControl: false
    panControl: false
    overviewMapControl: true
    mapTypeControl: true
    mapTypeId: google.maps.MapTypeId.ROADMAP
    maxZoom: 17
    minZoom: 11

  @map = map
  @directionsDisplay.setMap(map)
  @directionsDisplay.setOptions suppressMarkers: true
  @travelMarkerImage = 
    start: new (google.maps.MarkerImage)('/images/map-marker-active.png', new (google.maps.Size)(50, 60), new (google.maps.Point)(0, 0), new (google.maps.Point)(22, 32))
    end: new (google.maps.MarkerImage)('/images/map-marker-active2.png', new (google.maps.Size)(50, 60), new (google.maps.Point)(0, 0), new (google.maps.Point)(22, 32))

  @travelMarkers = 
    start: new (google.maps.Marker)(icon: @travelMarkerImage.start, title: 'title')
    end: new (google.maps.Marker)(icon: @travelMarkerImage.end, title: 'title')

  infoWindowId = null
  infowindow = new google.maps.InfoWindow()

  if Session.get("enteredAddress")
    from = "#{building.address} #{cities[building.cityId].short}"
    to = "#{Session.get("enteredAddress")} #{cities[building.cityId].short}"
    calcRoute(from, to, @)

  if Session.get("cityGeoLocation")
    address = Session.get("cityGeoLocation")

    if building.latitude and building.longitude
      latLng = new google.maps.LatLng(building.latitude, building.longitude)
      map.setCenter(latLng)

  else
    if building.latitude and building.longitude
      latLng = new google.maps.LatLng(building.latitude, building.longitude)
      map.setCenter(latLng)
      @travelMarkers.start.setMap(map)

      @autorun ->
        buildingReactive = Buildings.findOne(building._id, {fields: {latitude: 1, longitude: 1}})
        latLng = new google.maps.LatLng(buildingReactive.latitude, buildingReactive.longitude)
        map.setCenter(latLng)
        if instance.travelMarkers
          instance.travelMarkers.start.setPosition(latLng)

  ###
  $(".rating-pie-chart").easyPieChart
    size: 32
    barColor: "#3fabe1"
    trackColor: "#f2f2f2"
    scaleColor: "#dfe0e0"
    lineCap: "round"
    animate: 2300
  ###


  $(".building-unit-list-wrap>ul").niceScroll
    bouncescroll: true
    cursorborder: 0
    cursorborderradius: "8px"
    cursorcolor: "#404142"
    cursorwidth: "9px"
    zindex: 9999
    mousescrollstep: 26
    scrollspeed: 42
    autohidemode: "cursor"
    hidecursordelay: 500
    horizrailenabled: false

  Meteor.setTimeout ->
    # Bug with SEO package causes Building pages not to get a Title if you navigate directly to it.
    # Addressing temporarily by setting here (which doesn't help for SEO, so need a server side fix eventually.)

    if document.title is ""
      console.log("Title was not set, setting now")
      console.log(building.title)
      buildingTitle = (if building.title then building.title else building.city)
      document.title = buildingTitle + " Rentals | Rent Scene"
  , 1000

  # Show Check Availability Popup after 14 seconds
  if !Meteor.user() and $(window).width() > 768
    @popupTimeoutHandle = Meteor.setTimeout ->
      unless Session.get "hasSeenCheckAvailabilityPopup" == true || Session.get "hasSeenContactUsPopup" == true
        unless $('body').hasClass('modal-open')
          $('.check-availability').trigger('click')
    , 14000


Template.building.onDestroyed ->
  if $('main').hasClass('container')
    #console.log("building.onDestroyed -> main had .container, removing it")
    $('main').removeClass('container')

  # Clear timeout when user exits the page so it doesn't trigger.
  Meteor.clearTimeout(@popupTimeoutHandle)

Template.building.events
  "click .travel-mode-icon img": (event, template) ->
    $item = $(event.currentTarget)
    
    $("#walk-icon").find("img").attr("src", "/images/walk.png")
    $("#drive-icon").find("img").attr("src", "/images/car.png")
    $("#bike-icon").find("img").attr("src", "/images/bike.png")

    currentSrc = $item.attr('src')
    $item.attr('src', currentSrc.replace('.png', '-active.png'))
    Session.set "travelMode", $item.data('travel-mode')

    building = template.data.building
    from = "#{building.address} #{cities[building.cityId].short}"
    to = "#{Session.get("enteredAddress")} #{cities[building.cityId].short}"
    calcRoute(from, to, template)

  "click #route-address":  (event, template) ->
    $item = $(event.currentTarget)
    destination = $("#address").val()

    Session.set "travelMode", 'walking' if not Session.get "travelMode"

    Session.set('enteredAddress', destination)
    
    building = template.data.building
    from = "#{building.address} #{cities[building.cityId].short}"
    to = "#{destination} #{cities[building.cityId].short}"
    calcRoute(from, to, template)

  "keydown #address": (event, template) ->
    keypressed = event.keyCode || event.which;
    template.$('#route-address').click() if keypressed is 13

  "click .check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    analytics.track "Clicked Check Availability Btn (Building)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')

  "click .unit-check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    analytics.track "Clicked Check Availability Of Unit Btn" unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')

  ###
  # CC (Jan 2016): these 2 are not needed anymore - changed the way units are displayed within the building template,
  #                now they are all loaded from the beginning, and any overlow is handled with a scrollbar
  "click .building-unit-item-more": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", true)

  "click .building-unit-item-less": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", false)
  ###

  "click .remove-image": grab encapsulate (event, template) ->
    imageToRemove = @
    console.log(imageToRemove)

    swal
      title: "Delete Picture Confirmation"
      text: "You are about to permanently delete that picture - this <strong>cannot be un-done</strong>.  Do you still want to delete this picture?"
      type: "warning"
      confirmButtonColor: "#4588fa"
      confirmButtonText: "Delete"
      closeOnConfirm: false
      showCancelButton: true
      cancelButtonText: "Cancel"
      showLoaderOnConfirm: true
      html: true
      , (isConfirm) ->
        if isConfirm
          if imageToRemove instanceof FS.File
            query = {"EJSON$value.EJSON_id": imageToRemove._id }
          else if imageToRemove.vimeoId?
            query = {"_id": imageToRemove._id }

          if query
            Buildings.update({ _id: template.data.building._id}, { $pull: { images: query }})
            swal
              title: "Picture Deleted"
              text: "That picture has been deleted successfully."
              type: "success"
              confirmButtonColor: "#4588fa"


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
    swal
      title: "Delete Building Confirmation"
      text: "You are about to permanently delete this building - this <strong>cannot be un-done</strong>.  Do you still want to delete this building?"
      type: "warning"
      confirmButtonColor: "#4588fa"
      confirmButtonText: "Delete"
      closeOnConfirm: false
      showCancelButton: true
      cancelButtonText: "Cancel"
      showLoaderOnConfirm: true
      html: true
      , (isConfirm) ->
        if isConfirm
          building = template.data.building
          Buildings.remove(building._id)
          parent = building.parent()
          type = "Building"

          if parent
            type = "Unit"
            Router.go("building", parent.getRouteData())
          else
            Router.go("city", {cityId: building.cityId})

          swal
            title: type + " Deleted"
            text: "That building has been deleted successfully."
            type: "success"
            confirmButtonColor: "#4588fa"


  "click .edit-building": (event, template) ->
    Session.set("editBuildingId", template.data.building._id)

    Meteor.setTimeout ->
      #console.log("building.coffee -> Timeout block")
      $(".fg-input").each (index) ->
        val = $(this).val()
        if val.length > 0
          $(this).closest(".fg-line").addClass "fg-toggled"
    , 250


  "click .cancel-building": (event, template) ->
    Session.set("editBuildingId", null)

  "click .save-building": (event, template) ->
    $('.building-form').submit()

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

Template.building.helpers
  'buildingIsRecommended': ->
    clientObject = Session.get "recommendationsClientObject"
    if clientObject
      clientId = clientObject.clientId
      ClientRecommendations.find({_id: clientId, 'buildingIds': @._id}).count()

  'unitIsRecommended': ->
    clientObject = Session.get "recommendationsClientObject"
    if clientObject
      clientId = clientObject.clientId
      ClientRecommendations.find({_id: clientId, 'unitIds.unitId': @._id}).count()

Template.building.events
  "click .building-info-wrap .recommend-toggle": (event, template) ->
    clientObject = Session.get "recommendationsClientObject"
    if clientObject
      clientId = clientObject.clientId
      if Template.building.__helpers[" buildingIsRecommended"].call(@) is 0
        Meteor.call 'recommendBuilding', clientId, @._id
      else
        Meteor.call 'unrecommendBuilding', clientId, @._id

  "click .building-unit-item .recommend-toggle": (event, template) ->
    clientObject = Session.get "recommendationsClientObject"
    if clientObject
      clientId = clientObject.clientId
      if Template.building.__helpers[" unitIsRecommended"].call(@) is 0
        Meteor.call 'recommendUnit', clientId, @._id, @.parentId
      else
        Meteor.call 'unrecommendUnit', clientId, @._id

updateBuilding = (buildingId, newObject, item) ->
  Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}})
  item.find(".loading").hide()

calcRoute = (from, to, context) ->
  directionsService = context.directionsService
  directionsDisplay = context.directionsDisplay
  map = context.map
  travelMarkers = context.travelMarkers

  # Calculate travel duration for all three modes of travel
  travelModes = ['driving', 'bicycling', 'walking']

  for mode in travelModes
    request = 
      origin: from
      destination: to
      travelMode: google.maps.TravelMode[mode.toUpperCase()]

    directionsService.route request, (result, status) ->
      if status == google.maps.DirectionsStatus.OK
        mode = result.request.travelMode.toLowerCase()
        leg = result.routes[0].legs[0]

        duration = leg.duration.text
        $("##{mode}-travel-time").html(duration)

        travelTimes = Session.get('travelTimes')
        travelTimes[mode] = duration

        Session.set('travelTimes', travelTimes)

        if Session.equals('travelMode', mode)
          directionsDisplay.setDirections result

          travelMarkers.start.setPosition leg.start_location
          travelMarkers.end.setPosition leg.end_location

          travelMarkers.start.setMap(context.map)
          travelMarkers.end.setMap(context.map)

          switch mode
            when 'driving'
              travelIcon = 'car'
              travelText = 'drive'
            when 'walking'
              travelIcon = 'male'
              travelText = 'walk'
            when 'bicycling'
              travelIcon = 'bicycle'
              travelText = 'bike ride'

          context.travelInfoWindow.setContent('<i class="fa fa-fw fa-' + travelIcon + '"><span class="travel-duration"><span>#{leg.duration.text}</span> #{travelText} home' + '</span><br/><span class="travel-distance">(' + leg.distance.text + ')</span>')
          context.travelInfoWindow.setPosition(leg.start_location)
          context.travelInfoWindow.open(map)
          $('.gm-style-iw').next('div').hide()

CalculateDistance = (lat1, lon1, lat2, lon2) ->
  radlat1 = Math.PI * lat1 / 180
  radlat2 = Math.PI * lat2 / 180
  radlon1 = Math.PI * lon1 / 180
  radlon2 = Math.PI * lon2 / 180
  theta = lon1 - lon2
  radtheta = Math.PI * theta / 180
  dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
  dist = Math.acos(dist)
  dist = dist * 180 / Math.PI
  dist = dist * 60 * 1.1515
  #console.log dist
