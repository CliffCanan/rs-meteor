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
