Template.building.helpers

Template.building.rendered = ->

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('show')