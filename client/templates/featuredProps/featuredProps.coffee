Template.index.helpers


Template.index.rendered = ->



Template.index.events
  "click .example": (event, template) ->
    $('.city-list').slideUp()

  "click #example1": grab encapsulate (event, template) ->
    analytics.track "Clicked Work with an expert button"
    $('#contactUsPopup').modal('show')

  "click #example": (event, template) ->
    event.stopPropagation()
    event.preventDefault()
    analytics.track "Clicked Browse Listings button"
    $('.city-list').slideToggle()

  "click #example": grab encapsulate (event, template) ->
    analytics.track "Clicked Get Started button"
    $('#contactUsPopup').modal('show')