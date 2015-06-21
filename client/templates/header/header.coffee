Template.header.helpers
  loggedInUser: ->
    Meteor.user()
  canManageClients: ->
    Security.canManageClients()
  isRecommending: ->
    Session.get("recommendationsClientObject")
  recommendationsClientName: ->
    clientObject = Session.get("recommendationsClientObject")
    clientObject.name
  clientRecommendationsRouteData: ->
    clientObject = Session.get("recommendationsClientObject")
    clientId: clientObject.clientId

Template.header.onRendered ->
  @autorun ->
    if Template.header.__helpers[" isRecommending"].call(@)
      $('main').css('margin-top': 122)
    else
      $('main').css('margin-top': 70)

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')

  "click #exit-recommendation": (event, template) ->
    Session.set "recommendationsClientObject", null
    Session.set "showRecommendations", null
    Router.go "/"
    return