updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.rendered = ->
  updateScroll()

Template.cityBuildings.helpers
  checkAvailable: (id) ->
  	if  Session.get("addressgeo")
  		filtered = Session.get 'filtered'
  		if filtered.indexOf(id) == -1
  			#console.log "a"
  			return false
  		else 
  			#console.log "b"
  			return true
  	else
  		#console.log "c"
  		return true
  shouldShowRecommendToggle: ->
    Router.current().route.getName() is "clientRecommendations" and Security.canManageClients()
  isRecommended: ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds
  getThumbnail: (store) ->
    share.getThumbnail.call @, store
  mediaClass: ->
    return 'video' if @vimeoId?
  isVideo: ->
    @vimeoId?

convertTimeToMins = (time) ->
  if time.indexOf("days") == -1
    if time.indexOf("hours") == -1
      parseInt time.split("hours")[0]
    else
      hours = parseInt time.split("hours")[0]
      mins = parseInt time.split("hours")[1]
      hours * 60 + mins
  else 
    days = parseInt time.split("days")[0]
    hours = time.split("days")[1]
    hours = parseInt hours.split("hours")[0]
    days * 1440 + hours * 60

getAvaiability = (request, directionsService, cb) ->
  directionsService.route request, (response, status) ->
    if status == 'OK'
      point = response.routes[0].legs[0]
      mins = convertTimeToMins(point.duration.text)
      cb(mins)
  
# Separate events for recommend toggle
Template.cityBuildings.events
  "click .recommend-toggle": (event, template) ->
    clientId = Router.current().data().clientId
    buildingId = @._id
    buildingIds = Router.current().data().buildingIds || []

    if @._id in buildingIds
      Meteor.call "unrecommendBuilding", clientId, buildingId
    else
      Meteor.call "recommendBuilding", clientId, buildingId

