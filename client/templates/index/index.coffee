Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->

Template.index.events
  "click .head-section-wrap": (event, template) ->
    $('.city-list').slideUp()
  "click .contact-us, click #expert-button": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
  "click #expert-button": (event, template) ->
    analytics.track "Clicked Work with an expert button"
  "click #browse-button": (event, template) ->
    event.stopPropagation()
    event.preventDefault()
    analytics.track "Clicked Browse Listings button"
    $('.city-list').slideToggle()