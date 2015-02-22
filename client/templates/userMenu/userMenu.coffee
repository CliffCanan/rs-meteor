Template.userMenu.helpers
  userName: ->
    Meteor.user().profile.name

Template.userMenu.rendered = ->

Template.userMenu.events
#  "click .selector": (event, template) ->
