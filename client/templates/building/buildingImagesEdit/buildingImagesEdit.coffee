Template.buildingImagesEdit.rendered = ->
  building = @data
  $images = @$(".images-sortable-list")
  $images.sortable
    items: "> .images-sortable-item"
    placeholder: "images-sortable-placeholder col-lg-4 col-md-3 col-sm-3 col-xs-6"
    tolerance: "pointer"
    stop: (event, ui) ->
      order = $images.sortable("toArray", {attribute: "data-id"})
      Meteor.call("imagesOrder", building._id, order)

Template.buildingImagesEdit.events
  "click .add-video-btn": (event, template) ->
    $('#vimeo-popup').modal('show')