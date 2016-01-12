Template.featuredProps.helpers


Template.featuredProps.onRendered = ->
  #building = @data.building


Template.featuredProps.events
  "click .check-availability": grab encapsulate (event, template) ->
    console.log("Feature Props -> Check Availability Btn Clicked!")
    #Session.set("currentUnit", @)
    #analytics.track "Clicked Featured Unit Check Availability Btn ", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    $('#checkAvailabilityPopup').modal('show')