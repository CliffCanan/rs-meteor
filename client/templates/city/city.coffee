@setHeights = _.debounce ->
  $window = $(window)
  windowHeight = $window.outerHeight()
  if window.matchMedia("(min-width: 1200px)").matches
    headerHeight = $(".header-wrap").outerHeight()
    filterHeight = $(".city-sub-header").outerHeight()
    $(".right-bar, .left-bar").outerHeight(windowHeight - headerHeight - filterHeight)
  else
    $(".right-bar").outerHeight(windowHeight * 0.6)
    $(".left-bar").css("height", "auto")
, 100, true

$(window).on("resize", setHeights)

@setHeights = ->
  $window = $(window)
  windowHeight = $window.outerHeight()
  if window.matchMedia("(min-width: 1200px)").matches
    headerHeight = $(".header-wrap").outerHeight()
    filterHeight = $(".city-sub-header").outerHeight()
    $(".right-bar, .left-bar").outerHeight(windowHeight - headerHeight - filterHeight)
  else
    $(".right-bar").outerHeight(windowHeight * 0.6)
    $(".left-bar").css("height", "auto")

markers = {}

Template.city.onCreated ->
  @data.firstLoad = true
  @buildingsCount = new ReactiveVar(0)
  @viewType = new ReactiveVar('thumbnails')
  Session.set('adminShowUnpublishedProperties', false)

  unless $.fn.hoverIntent
    $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.hoverintent/1.8.1/jquery.hoverIntent.min.js'

Template.city.helpers
  showMap: ->
    Router.current().route.getName() isnt "clientRecommendations"
  firstLoad: ->
    citySubs.dep.depend()
    !citySubs.ready and @firstLoad
  isClientRecommendationsList: ->
    if Router.current().route.getName() is "clientRecommendations"
      $(".city-page-wrap").removeClass("col-lg-9").addClass("col-lg-12")
      return true
    else
      return true if Session.get('recommendationsClientObject')
      $(".city-page-wrap").removeClass("col-lg-12").addClass("col-lg-12")
    false
  showClientRecommendationsName: ->
    Template.city.__helpers[" isClientRecommendationsList"].call(@) and not Security.canManageClients()
  loadingBuildings: ->
    citySubs.dep.depend()
    ready = citySubs.ready
    if ready
      cityPageData = Session.get("neighborhoodPageData") or Session.get("cityPageData")
      Session.set("cityBuildingsLimit", cityPageData.page * itemsPerPage) if cityPageData
    !ready
  notAllLoaded: ->
    return false if Session.get "showRecommendations"
    Template.instance().buildingsCount.get() < Counts.get("city-buildings-count")
  # TODO: filter by price depend on btype

  buildings: ->
    filtered = []
    buildings = []

    query = Router.current().params.query
    controller = Router.current()
    if Session.get "showRecommendations"
      if Router.current().route.getName() is "clientRecommendations"
        buildingIds = Router.current().data().buildingIds or []
        selector = {_id: {$in: buildingIds}, $or: [{$and: [{isImportCompleted: {$exists: true}}, {isImportCompleted: true}]}, {isImportCompleted: {$exists: false}}]}
      else
        buildingIds = ClientRecommendations.findOne(Session.get('recommendationsClientObject')._id).buildingIds or []
        selector = {_id: {$in: buildingIds}, isPublished: true}
    else
      selector = {parentId: {$exists: false}, cityId: @cityId}
      selector.isPublished = true if not Session.get('adminShowUnpublishedProperties')

      if Template.instance().viewType.get() is 'thumbnails'
        limit = Session.get("cityBuildingsLimit")

      if @neighborhoodSlug
        selector.neighborhoodSlug = @neighborhoodSlug

      addQueryFilter(@query, selector, Meteor.userId())

      if query.hasOwnProperty('address') == true
        travelMode = Session.get "travelMode"

        arrivalTime = 0
        selectedTime = if Session.get "selectedTime" then Session.get "selectedTime" else 10
        selectedTime = parseInt selectedTime
        geocoder = new google.maps.Geocoder()
        currentCity = cities[@cityId].short
        address = "#{Session.get("cityName")} #{currentCity}"

        geocoder.geocode { 'address':  address }, (results, status) ->
          if status == google.maps.GeocoderStatus.OK
            i = 0
            while i < results.length
              result = results[i]
              city = result.formatted_address

              if city.trim().toUpperCase().indexOf(currentCity.toUpperCase()) != -1 
                location = results[i].geometry.location
                Session.set("cityGeoLocation", [location.lat(), location.lng()]) 
              i++

            if location == undefined
              #$(".form-building-filter")[0].reset();
              $(".form-building-filter").get(0).reset()
              $(".form-building-filter").trigger("submit")
              Session.set "cityGeoLocation", ""
              $('#messageAlert').modal('show')
            else
              Session.set("cityGeoLocation", [location.lat(), location.lng()])
            
        if Session.get "cityGeoLocation"
          buildings = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: limit})
          address = Session.get "cityGeoLocation"

          buildings.forEach (building) ->
            distance = CalculateDistance(address[0], address[1], building.latitude, building.longitude)*1.609344

            if travelMode == "walking"
              arrivalTime = distance / (5 / 60)
            if travelMode == "driving"
              arrivalTime = distance / (40 / 60)
            if travelMode == "bicycling"
              arrivalTime = distance / (15 / 60)

            if arrivalTime < selectedTime
              filtered.push building._id

          selector._id = {$in: filtered}
      else
        Session.set("cityGeoLocation", "")

    buildings = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: limit})

    Template.instance().buildingsCount.set(buildings.count())

    if Template.instance().viewType.get() is 'quickView'
      processedParents = []
      parents = buildings.fetch()

      if parents
        childSelector = {}

        # Remove agro* fields that only applied for parent buildings.
        _.each (_.keys selector), (key) ->
          childSelector[key] = selector[key] if key.indexOf('agro') is -1

        childSelector.btype = @query.btype if @query.btype
        _.each parents, (parent) ->
          childSelector.parentId = parent._id
          parent.isParent = true

          children = Buildings.find(childSelector)
          if children.count()
            parent.children = children.fetch()
            parent.hasChildren = true
          
          processedParents.push parent

        buildings = processedParents

    buildings

  currentViewType: ->
    switch Template.instance().viewType.get()
      when 'quickView' then return "Quick view"
      else return "Thumbnails"

  showThumbnails: ->
    Template.instance().viewType.get() is 'thumbnails'

Template.city.onRendered ->
  instance = @

  $.getScript '/js/imgLiquid-min.js', ->
    $('.main-city-item .item.video').imgLiquid();

  cityCircle = undefined

  @data.firstLoad = false
  setHeights()
  cityData = cities[@data.cityId]
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
  markers = {}
  defaultIcon = new google.maps.MarkerImage("/images/map-marker.png", null, null, null, new google.maps.Size(34, 40))
  activeIcon = new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null, new google.maps.Size(50, 60))
  filterIcon = new google.maps.MarkerImage("/images/map-marker-active2.png", null, null, null, new google.maps.Size(50, 60))  

  infoWindowId = null
  infowindow = new google.maps.InfoWindow()
  google.maps.event.addListener infowindow, "closeclick", ->
    if infoWindowId != null
      markers[infoWindowId].setIcon(defaultIcon)

  # Quick CSS hack to add proper margins for non staff in recommendation list since toggle buttons are float.
  # Staff has the 'Add Listing button' which is not floated and adds a nice margin
  @autorun ->
    if Router.current().route.getName() is "clientRecommendations" and not Security.canManageClients()
      $('.main-city-list').css marginTop: 53
    else
      $('.main-city-list').css marginTop: 0

    citySubs.dep.depend()
    if citySubs.ready
      data = Router.current().data()
      
      actualMarkerIds = []
      @template.__helpers[" buildings"].call(data).forEach (building) ->
        if building.latitude and building.longitude
          actualMarkerIds.push(building._id)
          if marker = markers[building._id]
            unless marker.map
              marker.setMap(map)
          else
            marker = new google.maps.Marker
              _id: building._id
              title: building.title
              position: new google.maps.LatLng(building.latitude, building.longitude)
              map: map
              icon: defaultIcon

            markers[building._id] = marker
            google.maps.event.addListener marker, "click", do (marker, building) ->->
              if infoWindowId isnt marker._id
                if infoWindowId
                  markers[infoWindowId].setIcon(defaultIcon)

                html = Blaze.toHTMLWithData(Template.buildingMarker, building)
                infowindow.setContent(html)
                infowindow.open(map, marker)
                infoWindowId = marker._id
                marker.setIcon(activeIcon)                

            google.maps.event.addListener marker, "mouseover", do (marker) ->->
              marker.setIcon(activeIcon)

            google.maps.event.addListener marker, "mouseout", do (marker) ->->
              if marker._id isnt infoWindowId
                marker.setIcon(defaultIcon)             

      for id, marker of markers
        unless id in actualMarkerIds
          marker.setMap(null)
    if cityCircle isnt undefined
      cityCircle.setMap(null)

    if Session.get "cityGeoLocation"
      if markers["filterItem"]
        markers["filterItem"].setMap(null)

      address = Session.get "cityGeoLocation"
      query = Router.current().params.query
      marker = new google.maps.Marker
        _id: "filterItem"
        title: query.address
        position: new google.maps.LatLng(address[0], address[1])
        map: map
        icon: filterIcon

      markers["filterItem"] = marker

      selectedTime = parseFloat(if Session.get('selectedTime') then Session.get('selectedTime') else 10)

      travelMode = Session.get('travelMode') or 'walking'

      if travelMode == "walking"
        maxDistance = selectedTime * (5 / 60)
      else if travelMode == "driving"
        maxDistance = selectedTime * (40 / 60)
      else if travelMode == "bicycling"
        maxDistance = selectedTime * (15 / 60)

      # Center map to entered address
      map.setCenter new google.maps.LatLng(address[0], address[1])

      populationOptions = 
        strokeColor: '#FF0000'
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: '#FF0000'
        fillOpacity: 0.35
        map: map
        center: new google.maps.LatLng(address[0], address[1])
        radius: maxDistance * 1000

      cityCircle = new (google.maps.Circle)(populationOptions)

    if Router.current().route.getName() is "clientRecommendations"
      if Session.get "showRecommendations"
        # Zoom map to fit all markers
        bounds = new google.maps.LatLngBounds();
        for i, marker of markers
          bounds.extend markers[i].getPosition() 
        map.fitBounds(bounds);
      else
        currentCityData = cities[data.cityId]
        map.setZoom(14)
        map.setCenter new google.maps.LatLng(currentCityData.latitude, currentCityData.longitude)

    else if Router.current().route.getName() is "neighborhood"
      # Center map to fit all properties
      bounds = new google.maps.LatLngBounds()
      for i, marker of markers
        bounds.extend markers[i].getPosition()     
      map.fitBounds(bounds)

  # Show Contact Us Popup after 14 seconds
  if Router.current().route.getName() != "clientRecommendations" and not Meteor.user()
    @popupTimeoutHandle = Meteor.setTimeout ->
      unless $('body').hasClass('modal-open')
        $('.contact-us').trigger('click')
    , 14000

  Meteor.setTimeout ->
    if typeof($('.HB-Bar')) != 'undefined'
      #console.log("Hiding .HB-Bar - End of Template.city.onRendered");
      $('.HB-Bar').addClass('hidden')
      $('#hellobar-pusher').addClass('hidden')
  , 200


  $("#contactUsPopup").on "hide.bs.modal", (e) ->
    $("#contactUsPopup form").formValidation "resetForm", true


incrementPageNumber = ->
  if Router.current().route.getName() is "city"
    cityPageData = Session.get("cityPageData")
    cityPageData.page++
    Session.set("cityPageData", cityPageData)
  else if Router.current().route.getName() is "neighborhood"
    neighborhoodPageData = Session.get("neighborhoodPageData")
    neighborhoodPageData.page++
    Session.set("neighborhoodPageData", neighborhoodPageData)

Template.city.onDestroyed ->
  Session.set('neighborhoodPageData', null)

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

Template.city.events
  "click .city-select li": (event, template) ->
    data = template.data
    cityId = $(event.currentTarget).attr("data-value")
    cityData = cities[cityId]
    template.map.setCenter(new google.maps.LatLng(cityData.latitude, cityData.longitude))

  "click .view-list-wrapper li": (event, template) ->
    viewType = $(event.currentTarget).attr('data-value')
    template.viewType.set viewType

  "mouseover .main-city-list li": (event, template) ->
    marker = markers[@_id]
    if marker
      google.maps.event.trigger(marker, "mouseover")

  "mouseout .main-city-list li": (event, template) ->
    marker = markers[@_id]
    if marker
      google.maps.event.trigger(marker, "mouseout")

  "click .load-more": (event, template) ->
    incrementPageNumber()

  "scroll .main-city-list-wrap": (event, template) ->
    $el = $(event.currentTarget)
    $container = $(".main-city-list", $el)
    scrollTop = $el.scrollTop()
    Session.set("cityScroll", scrollTop)
    if citySubs.ready and scrollTop >= $container.outerHeight() - $el.outerHeight()
      if template.view.template.__helpers[" notAllLoaded"].call(template.data)
        incrementPageNumber()

  "click .button-building-insert": (event, template) ->
    Meteor.apply "insertBuilding", [template.data.cityId], onResultReceived: (error, result) ->
      unless error
        Session.set("editBuildingId", result.buildingId)
        Router.go(result.url)

  "click .travelMode": (event, template) ->
    $item = $(event.currentTarget)
    setDefaultImagesForCalc()
    if $item.attr("id") == "walker-calc"
      $item.find('img').attr("src", "/images/walk-active.png")
      Session.set "distanceMode", "walk"
    if $item.attr("id") == "car-calc"
      $item.find('img').attr("src", "/images/car-active.png")
      Session.set "distanceMode", "drive"
    if $item.attr("id") == "bike-calc"
      $item.find('img').attr("src", "/images/bike-active.png")
      Session.set "distanceMode", "bike"

setDefaultImagesForCalc = ->
  $("#walker-calc").find("img").attr("src", "/images/walk.png")
  $("#car-calc").find("img").attr("src", "/images/car.png")
  $("#bike-calc").find("img").attr("src", "/images/bike.png")    

$("#contactUsPopup").on "hidden.bs.modal", ->
  $("#contactUsPopup form").formValidation "resetForm", true