Template.clientRecommendations.onRendered ->
  @autorun ->
    clientId = Router.current().data().clientId
    clientRecommendations = ClientRecommendations.findOne clientId
    clientObject =
      clientId: clientId
      name: clientRecommendations.name

    Session.set "recommendationsClientObject", clientObject
    Session.set "showRecommendations", true
    return