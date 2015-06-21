Template.header.helpers
  loggedInUser: ->
    Meteor.user()
  canManageClients: ->
    Security.canManageClients()
  shouldShowRecommendingBanner: ->
    Session.get("recommendationsClientObject") and Security.canManageClients()
  recommendationsClientName: ->
    clientObject = Session.get("recommendationsClientObject")
    clientObject.name

Template.header.onRendered ->
  @autorun ->
    if Template.header.__helpers[" isRecommending"].call(@)
      $('main').css('margin-top': 122)
    else
      $('main').css('margin-top': 70)

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')

  "click #view-recommendations": (event, template) ->
    event.preventDefault()
    clientObject = Session.get("recommendationsClientObject")
    Session.set "showRecommendations", true
    Router.go "clientRecommendations", clientId: clientObject.clientId
    return

  "click #exit-recommendation": (event, template) ->
    event.preventDefault()
    Session.set "recommendationsClientObject", null
    Session.set "showRecommendations", null
    Router.go "/"
    return