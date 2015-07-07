updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.onRendered ->
  updateScroll()
  _.defer ->
    $carousel = $(".carousel")
    carousel = $carousel.data("bs.carousel")
    if carousel
      carousel.pause()
      carousel.destroy()
    $firstItem = $carousel.find(".item:first")
    if $firstItem.length
      $firstItem.addClass("active")
      $carousel.show().carousel()
    else
      $carousel.hide()

Template.cityBuildings.helpers
  'shouldShowRecommendToggle': ->
    Router.current().route.getName() is "clientRecommendations" and Security.canManageClients()
  'isRecommended': ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds
  getThumbnail: (store) ->
    share.getThumbnail.call @, store
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