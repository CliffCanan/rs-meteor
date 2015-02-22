Template.addBuilding.helpers
  buildings: ->
    filter = Session.get("filter")
    $set = {}
    if @userList
      $set.cityId = @userList.cityId
      if filter
        $set.name = {}
        $set.name.$regex = ".*"+filter+".*"
      if @userList.buildingsIds
        $set._id = {}
        $set._id.$nin = @userList.buildingsIds
      return Buildings.find($set)


Template.addBuilding.rendered = ->
  Session.set("filter", "")

Template.addBuilding.events
  "click .add-building": (event, template) ->
    if event.currentTarget.id not in propertiesToAdd
      workWithArray("add", event.currentTarget.id)
    else
      workWithArray("remove", event.currentTarget.id)
  "click .add-button": grab encapsulate (event, template) ->
    UserLists.update({_id: @userList._id}, {$addToSet: { buildingsIds: { $each: workWithArray("get")}}}, callback = (error, count) ->
        if error
          cl error
        else
          cl count
    )
    workWithArray("clean")
    $('#addBuildingPopup').modal('hide')
  "keyup .result-filter": grab encapsulate (event, template) ->
    Session.set("filter", event.currentTarget.value)

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
