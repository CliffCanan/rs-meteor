Template.usersPanel.helpers
  isntSuperAdmin: ->
    Meteor.user().role isnt "super"

  isAdmin: ->
    Meteor.user().role in ["admin", "super", "staff"]

  isStaff: ->
    Meteor.user().role is "staff"

  email: ->
    @emails[0]?.address
    
  users: ->
    Meteor.users.find()

Template.usersPanel.rendered = ->

Template.usersPanel.events
  "change .user-role": (event, template) ->
    Meteor.users.update({_id: @._id}, {$set : {role: event.currentTarget.value}})
