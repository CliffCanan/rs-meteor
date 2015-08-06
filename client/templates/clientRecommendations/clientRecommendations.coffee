Template.clientRecommendations.onCreated ->
  recommendation = @data

  (unitIds = recommendation.unitIds.map (value) -> value.unitId) if recommendation.unitIds?
  recommendedIds = recommendation.buildingIds.concat(unitIds) if recommendation.buildingIds?

  @subscribe("recommendedBuildings", recommendedIds) if recommendedIds

Template.clientRecommendations.onRendered ->
  instance = @
  @autorun ->
    clientId = Router.current().data().clientId
    clientRecommendations = ClientRecommendations.findOne clientId
    if clientRecommendations
      params = Router.current().params
      subscriptionQuery = _.omit(params.query, 'cityId')

      firstBuilding = Buildings.findOne(clientRecommendations.buildingIds[0]) if clientRecommendations.buildingIds
      firstCityId = if firstBuilding then firstBuilding.cityId else 'atlanta'
      cityId = if params.query.cityId then params.query.cityId else firstCityId

      citySubs.subscribe("buildings", cityId, subscriptionQuery, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
      instance.subscribe("city-buildings-count", params.cityId, subscriptionQuery)

      clientObject =
        clientId: clientId
        name: clientRecommendations.name

      Session.set "recommendationsClientObject", clientObject

      if Session.get("showRecommendations") isnt false
        Session.set "showRecommendations", true
        return