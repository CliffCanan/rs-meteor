class ClientRecommendation
  constructor: (doc) ->
    _.extend(@, doc)
  findUnitByParent: (parentId) ->
    _.find @.unitIds, (item) ->
      item.parentId is parentId

share.Transformations.ClientRecommendation = _.partial(share.transform, ClientRecommendation)

@ClientRecommendations = new Mongo.Collection "client_recommendations",
  transform: if Meteor.isClient then share.Transformations.ClientRecommendation else null