Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->

Template.index.events
  "click .head-section-wrap": (event, template) ->
    $('.city-list').slideUp()
  "click .contact-us, click #expert-button": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
  "click #browse-button": (event, template) ->
    event.stopPropagation()
    event.preventDefault()
    $('.city-list').slideToggle()