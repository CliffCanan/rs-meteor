Template.city.helpers
  buildings: ->
    selector = {cityId: @cityId}
    if btype = @query.btype
      selector[btype] = {$exists: true}
    if priceMin = @query.priceMin
      selector.priceMin = {$gte: parseInt(priceMin)}
    if priceMax = @query.priceMax
      selector.priceMin = {$lte: parseInt(priceMax)}
    Buildings.find(selector)
  randomImage: ->
#    images = [
#      "/images/search-img1.jpg"
#      "/images/search-img2.jpg"
#      "/images/search-img3.jpg"
#    ]
#    images[Math.floor(Math.random() * images.length)]
    "/images/search-img3.jpg"

Template.city.rendered = ->
  map = new google.maps.Map document.getElementById("gmap"),
    zoom: 14
    center: new google.maps.LatLng(39.95, -75.17) # TODO: set city center
    streetViewControl: false
    scaleControl: false
    rotateControl: false
    panControl: false
    overviewMapControl: false
    mapTypeControl: false
    mapTypeId: google.maps.MapTypeId.ROADMAP
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
            html = ''
            image = building.images[0]
            if image
              html += Blaze.toHTMLWithData(Template.buildingMarker, building)
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
