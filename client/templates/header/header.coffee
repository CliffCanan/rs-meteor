Template.header.helpers
  loggedInUser: ->
    Meteor.user()
  canManageClients: ->
    Security.canManageClients()

Template.header.rendered = ->

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
