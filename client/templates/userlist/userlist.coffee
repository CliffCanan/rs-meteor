Template.userlist.helpers
#  Only for Dave
  customerName: ->
    @userList.customerId

  buildings: ->
    Buildings.find(_id: {$in: @userList.buildingsIds}).fetch()

Template.userlist.rendered = ->


Template.userlist.events
#  "click .selector": (event, template) ->
