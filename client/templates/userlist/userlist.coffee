Template.userlist.helpers
  customerName: ->
    Meteor.users.findOne(_id: @userList.customerId).name
  buildings: ->
    UserListBuildings.find(_id: {$in: @userList.buildingsIds}).fetch()

Template.userlist.rendered = ->


Template.userlist.events
#  "click .selector": (event, template) ->
