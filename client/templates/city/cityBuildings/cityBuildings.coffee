updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.onRendered ->
  updateScroll()

  instance = Template.instance()

  $('[data-toggle="tooltip"]').tooltip() if $(window).width() > 1030

  _.defer ->
    $('[data-toggle="tooltip"]').tooltip() if $(window).width() > 1030

    $(".main-city-list").hoverIntent ->
      if $(window).width() < 1100
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

  isMobile: ->
    if $(window).width() < 1030
      return true

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
    event.stopPropagation()

    clientId = Router.current().data().clientId
    buildingId = @._id
    buildingIds = Router.current().data().buildingIds || []

    if @._id in buildingIds
      Meteor.call "unrecommendBuilding", clientId, buildingId
    else
      Meteor.call "recommendBuilding", clientId, buildingId

    false

  "click .check-avail-option": (event, template) ->
    event.stopPropagation()

    # First close any open galleries on the page
    $('.ext-gallery:not(.hidden)').addClass('hidden')
    $('.main-city-img-link.hidden').removeClass('hidden')

    Session.set("currentUnit", @)
    console.log(@)

    analytics.track "Clicked Check Availability Btn (Search)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')
    false

  "click .view-pics-option": (event, template) ->
    event.stopPropagation()

    # First close any open galleries on the page
    $('.ext-gallery').addClass('hidden')
    $('.main-city-img-link').removeClass('hidden')

    # Then find the parent '.main-city-item' for the clicked Building in order to show the correct gallery
    parentEl = $(event.currentTarget).closest('.main-city-item')

    gallery = parentEl.find('.ext-gallery')
    initialImg = parentEl.find('.main-city-img-link')

    gallery.removeClass('hidden')  if gallery.hasClass('hidden')
    initialImg.addClass('hidden')

    # Now check which horizontal position the clicked building is (there are 3 buildings per row on lg screens...
    # But since the gallery is absolutely positioned relative to the parent item, it will be too far right for
    # positions 2 & 3, so need to correct for that here.
    xPosition = parentEl.offset().left
    if xPosition > 100
      correctionAmount = (0 - xPosition + 30).toString()
      correctionAmount += 'px'

      gallery.css('left',correctionAmount)

    analytics.track "Clicked View Pictures (Search)", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()

    # Finally instantiate the Owl Carousel
    gallery.find('.owl-carousel').owlCarousel
      items: 3
      pagination: false

    false

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
