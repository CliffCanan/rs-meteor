Template.buildingAdminFieldsEdit.helpers
  canBeSameBuildings: ->
    Buildings.find({agroCanBeSame: true, parentId: {$exists: false}}, {sort: {title: 1}})
  adminBuilding: ->
    adminSameId = Session.get("adminSameId")
    if adminSameId then Buildings.findOne(adminSameId) else @

Template.buildingAdminFieldsEdit.created = ->
  Session.set("adminSameId", @data.adminSameId)

Template.buildingAdminFieldsEdit.events
  "change .select-admin-same-id": (event, template) ->
    value = $(event.currentTarget).val()
    Session.set("adminSameId", if value.length then value else null)
