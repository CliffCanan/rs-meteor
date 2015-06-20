updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.rendered = ->
  updateScroll()

Template.cityBuildings.helpers
  'shouldShowRecommendToggle': ->
    Router.current().route.getName() is "clientRecommendations" and Security.canManageClients()
  'isRecommended': ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds

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