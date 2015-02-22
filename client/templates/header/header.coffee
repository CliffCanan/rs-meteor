Template.header.helpers
  loggedInUser: ->
    cl Meteor.user()
    Meteor.user()

Template.header.rendered = ->

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
