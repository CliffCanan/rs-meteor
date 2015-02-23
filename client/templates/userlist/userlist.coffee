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
        buildingsFound = Buildings.find(_id: {$in: @userList.buildingsIds}).fetch()
      if buildingsFound
        for building in buildingsFound
          if building.studio
            building.bedrooms = "Studio"
          if building["1bedroom"]
            if building.bedrooms.length > 0
              building.bedrooms += ", "
            building.bedrooms += "1"
          if building["2bedroom"]
            if building.bedrooms.length > 0
              building.bedrooms += ", "
            building.bedrooms += "2"
          if building["3bedroom"]
            if building.bedrooms.length > 0
              building.bedrooms += ", "
            building.bedrooms += "3"
          if building["4bedroom"]
            if building.bedrooms.length > 0
              building.bedrooms += ", "
            building.bedrooms += "4"
          if building.bedrooms.length > 0 and building.bedrooms isnt "Studio"
            building.bedrooms += " Bedrooms"
    buildingsFound

Template.userlist.rendered = ->

Template.userlist.events
  "click .add-building": (event, template) ->
    $('#addBuildingPopup').modal('show')
  "click .remove-property": (event, template) ->
    UserLists.update({_id: template.data.userList._id},{$pull:{buildingsIds: event.currentTarget.id}})

