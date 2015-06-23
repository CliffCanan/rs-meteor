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

Template.city.helpers
  firstLoad: ->
    citySubs.dep.depend()
    !citySubs.ready and @firstLoad
  clientRecommendationsList: ->
    Router.current().route.getName() is "clientRecommendations"
  loadingBuildings: ->
    citySubs.dep.depend()
    ready = citySubs.ready
    if ready
      cityPageData = Session.get("cityPageData")
      Session.set("cityBuildingsLimit", cityPageData.page * itemsPerPage) if cityPageData
    !ready
  notAllLoaded: ->
    return false if Session.get "showRecommendations"
    Template.city.__helpers[" buildings"].call(@).count() < Counts.get("city-buildings-count")
  # TODO: filter by price depend on btype
  buildings: ->
    _.defer ->
      wrap = $(".main-city-list-wrap").get(0)
      wrap.style.display = "none"
      wrap.offsetHeight # no need to store this anywhere, the reference is enough
      wrap.style.display = ""

    if Session.get "showRecommendations"
      buildingIds = Router.current().data().buildingIds
      selector = {_id: {'$in': buildingIds}}
    else
      selector = {parentId: {$exists: false}, cityId: @cityId}
      addQueryFilter(@query, selector)

    Buildings.find(selector, {sort: {position: -1, createdAt: -1, _id: 1}, limit: Session.get("cityBuildingsLimit")})

Template.city.created = ->
  @data.firstLoad = true

Template.city.rendered = ->
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
  infoWindowId = null
  infowindow = new google.maps.InfoWindow()
  google.maps.event.addListener infowindow, "closeclick", ->
    markers[infoWindowId].setIcon(defaultIcon)

  # Quick CSS hack to add proper margins for non staff in recommendation list since toggle buttons are float.
  # Staff has the 'Add Listing button' which is not floated and adds a nice margin
  if Router.current().route.getName() is "clientRecommendations" and not Security.canManageClients()
    $('.main-city-list').css marginTop: 53
  @autorun ->
    citySubs.dep.depend()
    if citySubs.ready
      if Session.get "showRecommendations"
        map.setZoom(3)
        map.setCenter new google.maps.LatLng(31.850033, -97.6500523)
      else
        map.setZoom(14)
        map.setCenter new google.maps.LatLng(cityData.latitude, cityData.longitude)
      data = Router.current().data()
      actualMarkerIds = []
      @template.__helpers[" buildings"].call(data).forEach (building) ->
        if building.isOnMap and building.latitude and building.longitude
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
                mixpanel.track("property-container-map")
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

incrementPageNumber = ->
  cityPageData = Session.get("cityPageData")
  cityPageData.page++
  Session.set("cityPageData", cityPageData)

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
    Session.set("cityScroll", $el.scrollTop())
    if citySubs.ready and template.view.template.__helpers[" notAllLoaded"].call(template.data)
      $container = $(".main-city-list", $el)
      if $el.scrollTop() >= $container.outerHeight() - $el.outerHeight()
        incrementPageNumber()

  "click .button-building-insert": (event, template) ->
    Meteor.apply "insertBuilding", [template.data.cityId], onResultReceived: (error, result) ->
      unless error
        Session.set("editBuildingId", result.buildingId)
        Router.go(result.url)
