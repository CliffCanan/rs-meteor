Template.buildingImagesEdit.rendered = ->
  building = @data
  $images = @$(".images-sortable-list")
  $images.sortable
    items: "> .images-sortable-item"
    placeholder: "images-sortable-placeholder col-md-3 col-sm-4 col-xs-6"
    tolerance: "pointer"
    stop: (event, ui) ->
      order = $images.sortable("toArray", {attribute: "data-id"})
      Meteor.call("imagesOrder", building._id, order)

Template.buildingImagesEdit.helpers
  getThumbnail: (store) ->
    share.getThumbnail.call @, store

  isVideo: ->
    return 'video' if @vimeoId?

Template.buildingImagesEdit.events
  "click .add-video-btn": (event, template) ->
    $('#vimeo-popup').modal('show')