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
    window.open("/pick-video/#{@._id}", 'vimeoVideos', 'height=574,width=700,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,directories=no,status=no')