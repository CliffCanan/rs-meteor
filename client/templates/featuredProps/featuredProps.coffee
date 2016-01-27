Template.featuredProps.helpers


Template.featuredProps.onRendered = ->
  #building = @data.building


Template.featuredProps.events
  "click .featured-props-wrap .check-availability": grab encapsulate (event, template) ->
    console.log("Feature Props -> Check Availability Btn Clicked!")
    
    #analytics.track "Clicked Featured Unit Check Availability Btn ", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()
    #$('#checkAvailabilityPopup').modal('show')

    analytics.track "Clicked Feature Property Check Availability" unless Meteor.user()
    $('#contactUsPopup form').formValidation 'resetForm', true
    $('#contactUsPopup').modal('show')