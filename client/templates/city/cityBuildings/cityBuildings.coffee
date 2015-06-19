updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityBuildings.rendered = ->
  updateScroll()

Template.cityBuildings.helpers
  'isRecommended': ->
    buildingIds = Router.current().data().buildingIds || []
    @._id in buildingIds
