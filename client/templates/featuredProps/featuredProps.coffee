Template.index.helpers


Template.featuredProps.onRendered = ->
  building = @data.building


Template.featuredProps.events
  "click .check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    analytics.track "Clicked Featured Unit Check Availability Btn ", {buildingId: @_id, buildingName: @title, label: @title}
    $('#checkAvailabilityPopup').modal('show')