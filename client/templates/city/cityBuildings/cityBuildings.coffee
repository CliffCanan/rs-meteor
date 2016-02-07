updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.onRendered ->
  updateScroll()

  instance = Template.instance()

  _.defer ->
    $('[data-toggle="tooltip"]').tooltip()

    $(".main-city-list").hoverIntent ->
      if not $(this).hasClass('images-subscribed')
        $carousel = $(this).find('.carousel')
        building = Blaze.getData(this)
        instance.subscribe "buildingImages", building._id
        $(this).addClass('images-subscribed')
    , '.main-city-img-link'


Template.cityBuildings.helpers

  checkAvailable: (id) ->
  	if  Session.get("addressgeo")
  		filtered = Session.get 'filtered'
  		if filtered.indexOf(id) == -1
  			return false
  		else 
  			return true
  	else
  		return true

  shouldShowRecommendToggle: ->
    Router.current().route.getName() is "clientRecommendations" and Security.canManageClients()

  isRecommended: ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds

  getThumbnail: (store) ->
    share.getThumbnail.call @, store

  mediaClass: ->
    classes = []
    classes.push 'active' if @_index is 0
    classes.push 'vimeo' if @vimeoId?
    classes.join ' '

  isVideo: ->
    @vimeoId?

  buildingImages: ->
    imageIds = _.map @images, (file) ->
      file._id
    index = 0
    images = _.map BuildingImages.find({_id: {$in: imageIds}}).fetch(), (item) ->
      item._index = index 
      index++
      item

    images

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

  "click .check-avail-option": (event, template) ->
    event.stopPropagation()

    # Session.set("currentUnit", @)
    console.log(@)
    # TEMPORARILY COMMENTING OUT analytics.track "Clicked Check Availability Btn (Search)" unless Meteor.user()
    $('#contactUsPopup').modal('show')
    false

  "click .view-pics-option": (event, template) ->
    event.stopPropagation()
    console.log('Photo Icon clicked!')
    false