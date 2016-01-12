Template.header.helpers
  loggedInUser: ->
    Meteor.user()
  canManageClients: ->
    canManage = Security.canManageClients()
    if canManage
      $('body').addClass('admin-logged-in') 
    else
      $('body').removeClass('admin-logged-in') 
    canManage
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
    analytics.track "Clicked Contact Us Header Btn" unless Meteor.user()
    $('#contactUsPopup form').formValidation 'resetForm', true
    $('#contactUsPopup').modal('show')

  "click #view-recommendations": (event, template) ->
    event.preventDefault()
    analytics.track "Clicked View Recommendations Btn" unless Meteor.user()
    clientObject = Session.get("recommendationsClientObject")
    Session.set "showRecommendations", true
    Router.go "clientRecommendations", clientId: clientObject.clientId
    return

  "click #exit-recommendation": (event, template) ->
    event.preventDefault()
    share.exitRecommendationsMode()
    return