Template.userlist.helpers
  agent: ->
    if Meteor.user() isnt null
      if @userList
        if not @userList.agentId
          UserLists.update({_id: @userList._id}, {$set: {agentId: Meteor.user()._id, agentName: Meteor.user().name}})
    Meteor.user() isnt null
  agentName: ->
    if @userList
      @userList.agentName
  noCity: ->
    if @userList
      if @userList.cityId is undefined
        $('#chooseCityPopup').modal('show')
        return true
    return false
  customerName: ->
    if @userList
      @userList.customerName
  buildings: ->
    buildingsFound = []
    if @userList
      if @userList.buildingsIds
        buildingsFound = Buildings.find(_id: {$in: @userList.buildingsIds})
    buildingsFound

Template.userlist.rendered = ->

Template.userlist.events
  "click .add-building": (event, template) ->
    $('#addBuildingPopup').modal('show')
  "click .remove-property": (event, template) ->
    UserLists.update({_id: template.data.userList._id},{$pull:{buildingsIds: event.currentTarget.id}})

