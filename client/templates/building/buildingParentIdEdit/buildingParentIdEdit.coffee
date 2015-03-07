Template.buildingParentIdEdit.helpers
  canHaveParentId: ->
    !Buildings.find({parentId: @_id}).count()

Template.buildingParentIdEdit.rendered = ->
  building = @data
  Meteor.call "getParentBuildingsChoices", building._id, (error, choices) ->
    $emptyOption = $("<option>").attr("value", "").text("-- No parent building --")
    $select = $("<select>").attr("name", "parentId").addClass("form-control").append($emptyOption)
    @$(".building-parent-id-select-placeholder").replaceWith($select)
    $select.select2({data: choices}).select2("val", building.parentId)
