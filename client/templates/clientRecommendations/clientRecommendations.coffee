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