updateScroll = ->
  if not Session.get "showRecommendations"
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))

Template.cityBuildings.onRendered ->
  @autorun => updateScroll()

  instance = Template.instance()

  Meteor.setTimeout ->
    $('[data-toggle="tooltip"]').tooltip() if $(window).width() > 1030
  , 1000

  _.defer ->
    $('[data-toggle="tooltip"]').tooltip() if $(window).width() > 1030

    unless $.fn.hoverIntent
      $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.hoverintent/1.8.1/jquery.hoverIntent.min.js', ->

        $(".main-city-list").hoverIntent ->

          if $(window).width() < 1100 or (Router.current().route.getName() is "clientRecommendations" and not Security.canManageClients())
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

  isFirstImage: ->
    @_index is 0
    
  isMobile: ->
    if $(window).width() < 1030
      return true

  showFullWidthView: ->
    Session.get("viewType") is 'fullWidth'


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

Template.cityBuildings.events
  "click .recommend-toggle": (event, template) ->
    event.preventDefault()

    clientId = Router.current().data().clientId
    buildingId = @._id
    buildingIds = Router.current().data().buildingIds || []

    if @._id in buildingIds
      Meteor.call "unrecommendBuilding", clientId, buildingId
    else
      Meteor.call "recommendBuilding", clientId, buildingId

  # Added by Cliff (4/28/16)
  "click .removeFromRecommendList": (event, template) ->
    event.stopPropagation()

    clientId = Router.current().data().clientId
    buildingId = @._id
    buildingIds = Router.current().data().buildingIds || []

    console.log(clientId)
    console.log(buildingId)

    if @._id in buildingIds
      Meteor.call "unrecommendBuilding", clientId, buildingId
      toastr.error('Listing Removed')

    false

  # Added by Cliff (4/28/16)
  "click .favoriteToggle": (event, template) ->
    event.stopPropagation()

    # WE DON'T HAVE A 'FAVORITES' FUNCTION PER SE, SO JUST SHOWING THE SUCCESS TOASTR FOR NOW..."

    #clientId = Router.current().data().clientId
    #buildingId = @._id
    #buildingIds = Router.current().data().buildingIds || []

    toastr.success('Listing Saved!')

    false

  "click .check-avail-option": (event, template) ->
    event.preventDefault()
    event.stopPropagation()

    # First close any open galleries on the page
    $('.ext-gallery:not(.hidden)').addClass('hidden')
    $('.main-city-img-link.hidden').removeClass('hidden')

    Session.set("currentUnit", @)
    console.log(@)

    analytics.track "Clicked Check Availability Btn (Search)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')
    false

  "click .checkAvail-recUnit": (event, template) ->
    event.stopPropagation()

    Session.set("currentUnit", @)

    analytics.track "Clicked Check Availability Btn (Recommended Unit)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')
    false

  "click .view-pics-option": (event, template) ->
    event.preventDefault()

    # fetch the rest images related to the building
    buildingId = $(event.currentTarget).attr "data-building-id"
    subscribeToBuildingImages template, buildingId

    analytics.track "Clicked View Pictures (Search)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()

  "click .ext-gallery .close-btn": (event, template) ->
    event.stopPropagation()

    parentEl = $(event.currentTarget).closest('.main-city-item')
    gallery = $(event.currentTarget).closest('.ext-gallery')
    initialImg = parentEl.find('.main-city-img-link')

    gallery.addClass('hidden')  unless gallery.hasClass('hidden')
    initialImg.removeClass('hidden') if initialImg.hasClass('hidden')

  "swiperight .building-img-wrap.carousel": (event, template) ->
    $arrowToTrigger = $(event.currentTarget).find('.carousel-control.left')
    $arrowToTrigger.trigger('click')

  "swipeleft .building-img-wrap.carousel": (event, template) ->
    $arrowToTrigger = $(event.currentTarget).find('.carousel-control.right')
    $arrowToTrigger.trigger('click')
