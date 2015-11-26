Template.header.helpers
  loggedInUser: ->
    Meteor.user()
  canManageClients: ->
    Security.canManageClients()
  recommendationsClientName: ->
    clientObject = Session.get("recommendationsClientObject")
    clientObject.name

Template.header.onRendered ->
  @autorun ->
    if share.canRecommend()
      $('main').css('margin-top': 122)
    else
      $('main').css('margin-top': 70)

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    analytics.track "Clicked Contact Us Link"
    $('#contactUsPopup').modal('show')

  "click #view-recommendations": (event, template) ->
    event.preventDefault()
    clientObject = Session.get("recommendationsClientObject")
    Session.set "showRecommendations", true
    Router.go "clientRecommendations", clientId: clientObject.clientId
    return

  "click #exit-recommendation": (event, template) ->
    event.preventDefault()
    share.exitRecommendationsMode()
    return