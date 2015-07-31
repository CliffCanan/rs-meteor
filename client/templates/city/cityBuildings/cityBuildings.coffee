updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.onRendered ->
  instance = @
  updateScroll()

  $(".carousel").each ->
    $carousel = $(this)
    carousel = $carousel.data("bs.carousel")
    if carousel
      carousel.pause()
      carousel.destroy()
    $firstItem = $carousel.find(".item:first")
    if $firstItem.length
      $firstItem.addClass("active")
      $carousel.show().carousel()

      $img = $firstItem.find('img')
      $img.attr 'src', $img.data('src')
    else
      $carousel.hide()

    $carousel.on 'slide.bs.carousel', (e) ->
      $img = $('img', e.relatedTarget);
      $img.attr 'src', $img.data('src')

  _.defer ->
    $(".carousel").hover ->
      if not $(this).hasClass('images-subscribed')
        building = Blaze.getData(this)
        instance.subscribe "buildingImages", building._id
        $(this).addClass('images-subscribed')

  $.getScript '/js/imgLiquid-min.js', ->
    $('.main-city-item .item.video').imgLiquid();

Template.cityBuildings.helpers
  'shouldShowRecommendToggle': ->
    Router.current().route.getName() is "clientRecommendations" and Security.canManageClients()
  'isRecommended': ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds
  getThumbnail: (store) ->
    share.getThumbnail.call @, store
  mediaClass: ->
    return 'video' if @vimeoId?
  isVideo: ->
    @vimeoId?

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