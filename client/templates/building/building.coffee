Template.building.helpers
  helper: ->
#    addthis.layers.refresh()
    return ""

Template.building.rendered = ->
  addthis.init()

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('show')