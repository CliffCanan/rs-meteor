Template.usersPanel.helpers
  isntSuperAdmin: ->
    Meteor.user().role isnt "super"
  isAdmin: ->
    Meteor.user().role in ["admin", "super", "staff"]
  isStaff: ->
    Meteor.user().role is "staff"
  users: ->
    Meteor.users.find()

Template.usersPanel.rendered = ->

Template.usersPanel.events
#  "click .selector": (event, template) ->
