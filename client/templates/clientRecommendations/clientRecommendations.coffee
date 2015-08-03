Template.clientRecommendations.onCreated ->
  # Subscribe to city buildings on created instead of waiting in router so recommendations page loads faster.
  Tracker.autorun ->
    params = Router.current().params
    subscriptionQuery = _.omit(params.query, 'cityId')

    # Reuse subscriptions manager in case the query has run before and we can use the cached version.
    citySubs.subscribe("buildings", params.cityId, subscriptionQuery, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
    citySubs.subscribe("city-buildings-count", params.cityId, subscriptionQuery)

Template.clientRecommendations.onRendered ->
  @autorun ->
    clientId = Router.current().data().clientId
    clientRecommendations = ClientRecommendations.findOne clientId
    if clientRecommendations
      clientObject =
        clientId: clientId
        name: clientRecommendations.name

      Session.set "recommendationsClientObject", clientObject

      if Session.get("showRecommendations") isnt false
        Session.set "showRecommendations", true
        return