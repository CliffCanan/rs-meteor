Template.buildingFeaturesEdit.helpers
  value: ->
    @features.join()

Template.buildingFeaturesEdit.rendered = ->
  @$(".building-features").tagit()
