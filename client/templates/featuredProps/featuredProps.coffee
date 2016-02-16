Template.featuredProps.helpers


Template.featuredProps.onRendered = ->
  #building = @data.building


Template.featuredProps.events
  "click .card-container *:not(.btn)": (event, template) ->
    if $(window).width() < 1030
      $cardToFlip = $(event.currentTarget).closest('.card-container')
      if $cardToFlip.hasClass('manual-flip') then $cardToFlip.removeClass('manual-flip') else $cardToFlip.addClass('manual-flip')

  "click .featured-props-wrap .check-availability": (event, template) ->
    event.stopPropagation()
    #console.log("Feature Props -> Check Availability Btn Clicked!")
    
    #analytics.track "Clicked Featured Unit Check Availability Btn ", {buildingId: @_id, buildingName: @title, label: @title} unless Meteor.user()

    analytics.track "Clicked Feature Property Check Availability" unless Meteor.user()
    $('#contactUsPopup form').formValidation 'resetForm', true
    $('#contactUsPopup').modal('show')