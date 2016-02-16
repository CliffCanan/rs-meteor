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

markers = {}

Template.city.onCreated ->
  @data.firstLoad = true
  @buildingsCount = new ReactiveVar(0)

  # Show Contact Us Popup after 18s (tablet/desktop) or 10s (mobile)
  if Router.current().route.getName() != "clientRecommendations" and not Meteor.user()

    delay = if $(window).width() < 768 then 10000 else 18000

    @popupTimeoutHandle = Meteor.setTimeout ->
      unless Session.get("hasSeenContactUsPopup") == true || $('body').hasClass('modal-open') || Session.get("currentPage") == "building"
        $('#contactUsPopup').modal('show')
    , delay

Template.city.helpers
  firstLoad: ->
    citySubs.dep.depend()
    !citySubs.ready and @firstLoad

  clientRecommendationsList: ->
    if Router.current().route.getName() is "clientRecommendations"
      return true

    false

  showClientRecommendationsName: ->
    Template.city.__helpers[" clientRecommendationsList"].call(@) and not Security.canManageClients()

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

    query = Router.current().params.query
    controller = Router.current()

    if Session.get "showRecommendations"
      buildingIds = Router.current().data().buildingIds
      selector = {_id: {$in: buildingIds}, $or: [{$and: [{isImportCompleted: {$exists: true}}, {isImportCompleted: true}]}, {isImportCompleted: {$exists: false}}]}
    else
      selector = {parentId: {$exists: false}, cityId: @cityId}
      selector.isPublished = true if not Session.get('adminShowUnpublishedProperties')

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
              $(".form-building-filter").get(0).reset()
              $(".form-building-filter").trigger("submit")
              Session.set "cityGeoLocation", ""

              swal
                title: "No Listings Near That Address"
                text: "We're always adding more listings in more areas but haven't gotten to that one yet. Please try another address, or email <a href='mailto:team@rentscene.com' target='_blank'>team@rentscene.com</a> to let us know we should prioritize this area."
                type: "warning"
                confirmButtonColor: "#4588fa"
                confirmButtonText: "Ok"
                html: true
            else
              # analytics.track "Filtered Listings By Location" # This might be duplicative, already tracking when Location Filter form is submitted, while this is on re-loading the page.
              Session.set("cityGeoLocation", [location.lat(), location.lng()])
            
        if Session.get "cityGeoLocation"
          buildings = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: Session.get("cityBuildingsLimit")})
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

    buildings = Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: Session.get("cityBuildingsLimit")})
    Template.instance().buildingsCount.set(buildings.count())

    buildings


  hasAnyFilters: ->
    if Session.get "currentNeighborhood"
      return true

    query = Router.current().params.query
    for prop of query
      return true  if query.hasOwnProperty(prop)
    false

  hasNeighborhood: ->
    if Session.get "currentNeighborhood"
      return true

  neighborhood: ->
    if Session.get "currentNeighborhood" isnt undefined
      Session.get "currentNeighborhood"
    else
      ""

  brTypeExist: ->
    query = Router.current().params.query
    query.hasOwnProperty('btype')

  brType: ->
    query = Router.current().params.query
    query.btype

  pets: ->
    query = Router.current().params.query
    query.hasOwnProperty('pets')

  parking: ->
    query = Router.current().params.query
    query.hasOwnProperty('parking')

  doorman: ->
    query = Router.current().params.query
    query.hasOwnProperty('security')

  fitnessCenter: ->
    query = Router.current().params.query
    query.hasOwnProperty('fitnessCenter')

  laundry: ->
    query = Router.current().params.query
    query.hasOwnProperty('laundry')

  utilities: ->
    query = Router.current().params.query
    query.hasOwnProperty('utilities')
  ###
  available: ->
    i = Template.instance().filterOptions.get()
    i.available

  fromPrice: ->
    i = Template.instance().filterOptions.get()
    i.fromPrice

  toPrice: ->
    i = Template.instance().filterOptions.get()
    i.toPrice
  ###

  isBizHours: ->
    currentTime = new Date()
    day = currentTime.getDay()
    hour = currentTime.getHours()
    if (day > 0 and day < 6 and hour > 7 and hour < 20) then true else false


Template.city.onRendered ->
  instance = @

  ###
  Meteor.setTimeout ->
    #console.log("Adding Nicescroll")
    unless $(".city-page-wrap").hasClass('hasNiceScroll')
      $(".city-page-wrap").addClass('hasNiceScroll').niceScroll
        bouncescroll: true
        cursorborder: 0
        cursorcolor: "#6C6E70"
        #cursorwidth: "9px"
        zindex: 9999
        mousescrollstep: 26 # default is 40 (px)
        scrollspeed: 42 # default is 60
        autohidemode: "cursor"
        #hidecursordelay: 700
        horizrailenabled: false
  , 1000
  ###
  
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
    mapTypeControl: true
    mapTypeId: google.maps.MapTypeId.ROADMAP
    maxZoom: 17
    minZoom: 11

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

  "click .neighborhoods-section .filter-list a": (event, template) ->
    $('.neighborhood-select .dropdown').removeClass('open')

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

  "click #show-unpublished-properties-toggle": (event, template) ->
    currentValue = Session.get('adminShowUnpublishedProperties')
    Session.set('adminShowUnpublishedProperties', !currentValue)

  "click .collapse-toggle-wrap#forMap": (event, template) ->
    $item = $(event.currentTarget)

    if $item.hasClass('is-out')
      $item.removeClass('is-out')
      $('.collapse-toggle-wrap#forMap .fa').removeClass('fa-chevron-circle-right').addClass('fa-chevron-circle-left')
      $('.collapse-toggle-wrap#forMap .btn span').text('Show Map')
      $('.collapse-toggle-wrap#forMap .btn').attr('data-original-title', 'Show map')
    else
      # First close any open galleries on the page
      $('.ext-gallery:not(.hidden)').addClass('hidden')
      $('.main-city-img-link.hidden').removeClass('hidden')

      $item.addClass('is-out')
      $('.collapse-toggle-wrap#forMap .fa').removeClass('fa-chevron-circle-left').addClass('fa-chevron-circle-right')
      $('.collapse-toggle-wrap#forMap .btn span').text('Hide Map')
      $('.collapse-toggle-wrap#forMap .btn').attr('data-original-title', 'Hide map')

#  "click .main-city-list-wrap": (event, template) ->
#    event.stopPropagation()
#    $('.ext-gallery:not(.hidden)').addClass('hidden')
#    $('.main-city-img-link.hidden').removeClass('hidden')

  "click #mobile-cta .btn": (event, template) ->
    analytics.track "Clicked Mobile CTA Btn (City Page)" unless Meteor.user()
    true

  "click #mobile-cta .close-btn": (event, template) ->
    $(this).fadeOut(150)
    $('#mobile-cta').slideUp(300)
    analytics.track "Clicked CLOSE Mobile CTA Btn (City Page)" unless Meteor.user()


setDefaultImagesForCalc = ->
  $("#walker-calc").find("img").attr("src", "/images/walk.png")
  $("#car-calc").find("img").attr("src", "/images/car.png")
  $("#bike-calc").find("img").attr("src", "/images/bike.png")    
