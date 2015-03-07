Template.buildingAdminFieldsEdit.helpers
  adminBuilding: ->
    building = @
    adminSameId = Session.get("adminSameId")
    if adminSameId
      adminSameIdBuildings = Session.get("adminSameIdBuildings")
      if same = adminSameIdBuildings?[adminSameId]
        building = same
    building

Template.buildingAdminFieldsEdit.created = ->
  Session.set("adminSameId", null)

Template.buildingAdminFieldsEdit.rendered = ->
  building = @data
  Meteor.call "getAdminSameChoices", building._id, (error, choices) ->
    $emptyOption = $("<option>").attr("value", "").text("-- Own data --")
    $select = $("<select>").attr("name", "adminSameId").addClass("form-control").append($emptyOption)
    @$(".building-admin-same-id-select-placeholder").replaceWith($select)
    $select.select2({data: choices}).select2("val", building.adminSameId)
    adminSameIdBuildings = {}
    for choice in choices
      adminSameIdBuildings[choice.id] = choice
    Session.set("adminSameIdBuildings", adminSameIdBuildings)
    Session.set("adminSameId", building.adminSameId)
    $select.on "change .select-admin-same-id", (event) ->
      value = $(@).val()
      Session.set("adminSameId", if value.length then value else null)
