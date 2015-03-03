setHeights = _.debounce ->
  windowHeight = $(window).outerHeight()
  headerHeight = $(".header-wrap").outerHeight()
  filterHeight = $(".city-sub-header").outerHeight()
  $(".city-side-bar").outerHeight(windowHeight - headerHeight)
  $(".main-city-list-wrap").outerHeight(windowHeight - headerHeight - filterHeight)
, 100, true

$(window).on("resize", setHeights)

markers = {}

Template.city.helpers
  loadingBuildings: ->
    citySubs.dep.depend()
    if citySubs.ready
      cityPageData = Session.get("cityPageData")
      Session.set("cityBuildingsLimit", cityPageData.page * itemsPerPage)
    !citySubs.ready
  # TODO: filter by price depend on btype
  buildings: ->
    selector = {parentId: {$exists: false}, cityId: @cityId}
    if btype = @query.btype
      fieldName = "price" + btype.charAt(0).toUpperCase() + btype.slice(1) + "From"
      selector[fieldName] = {$exists: true}
    priceMin = parseInt(@query.priceMin)
    priceMax = parseInt(@query.priceMax)
    unless isNaN(priceMin)
      min = priceMin
    unless  isNaN(priceMax)
      max = priceMax
    if min or max
      selector.agroPriceFilter = {}
      if min
        selector.agroPriceFilter.$gte = min
      if max
        selector.agroPriceFilter.$lte = max
    Buildings.find(selector, {sort: {createdAt: -1, _id: 1}, limit: Session.get("cityBuildingsLimit")})
  randomImage: ->
#    images = [
#      "/images/search-img1.jpg"
#      "/images/search-img2.jpg"
#      "/images/search-img3.jpg"
#    ]
#    images[Math.floor(Math.random() * images.length)]
    "/images/search-img3.jpg"

Template.city.rendered = ->
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
  infowindow = new google.maps.InfoWindow()
  markers = {}
  defaultIcon = new google.maps.MarkerImage("/images/map-marker.png", null, null, null, new google.maps.Size(34, 40))
  activeIcon = new google.maps.MarkerImage("/images/map-marker-active.png", null, null, null, new google.maps.Size(50, 60))
  infoWindowId = null
  @autorun ->
    data = Router.current().data()
    actualMarkerIds = []
    @template.__helpers[" buildings"].call(data).forEach (building) ->
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

            google.maps.event.addListener infowindow, "closeclick", ->
              markers[infoWindowId].setIcon(defaultIcon)

#            google.maps.event.addListener infowindow, "domready", ->
#              jQuery("#hook").parent().parent().css("left", "0")
#
#              jQuery(".gm-style-iw").width(220).css("top", "0")
#              jQuery(".gm-style-iw").parent().width(220)
#
#              elements = jQuery(".gm-style-iw").parent().find("div").eq(0).children()
#              for element in elements
#                jQuery(element).width(220)

        google.maps.event.addListener marker, "mouseover", do (marker) ->->
          marker.setIcon(activeIcon)

        google.maps.event.addListener marker, "mouseout", do (marker) ->->
          if marker._id isnt infoWindowId
            marker.setIcon(defaultIcon)

    for id, marker of markers
      unless id in actualMarkerIds
        marker.setMap(null)

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

  "scroll .main-city-list-wrap": (event, template) ->
    count = template.view.template.__helpers[" buildings"].call(template.data).count()
    if citySubs.ready and count < Counts.get("city-buildings-count")
      $el = $(event.currentTarget)
      $container = $(".main-city-list", $el)
      if $el.scrollTop() >= $container.outerHeight() - $el.outerHeight()
        cityPageData = Session.get("cityPageData")
        cityPageData.page++
        Session.set("cityPageData", cityPageData)

