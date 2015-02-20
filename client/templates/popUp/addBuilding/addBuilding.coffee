Template.addBuilding.helpers
  buildings: ->
    if @userList
      if @userList.buildingsIds
        return Buildings.find({cityId: @userList.cityId, _id: {$nin: @userList.buildingsIds}})
      else
        return Buildings.find({cityId: @userList.cityId})

Template.addBuilding.rendered = ->
  Session.set("serverError", false)

Template.addBuilding.events
  "click .add-building": (event, template) ->
    if event.currentTarget.id not in propertiesToAdd
      workWithArray("add", event.currentTarget.id)
    else
      workWithArray("remove", event.currentTarget.id)
    cl propertiesToAdd

  "click .add-button": grab encapsulate (event, template) ->
    cl "start", workWithArray("get")
    UserLists.update({_id: @userList._id}, {$addToSet: { buildingsIds: { $each: workWithArray("get")}}}, callback = (error, count) ->
        if error
          cl error
        else
          cl count
    )
    workWithArray("clean")
    cl "finish", workWithArray("get")
    $('#addBuildingPopup').modal('hide')

propertiesToAdd = []

workWithArray = (operation, value) ->
  switch operation
    when "add"
      propertiesToAdd.push(value)
    when "remove"
      propertiesToAdd.splice(propertiesToAdd.indexOf(value), 1)
    when "get"
      return propertiesToAdd
    when "clean"
      propertiesToAdd = []
