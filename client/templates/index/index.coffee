Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->

Template.index.events
  "click .contact-us, click #expert-button": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
  "click #browse-button": ->
    $('.city-list').slideToggle()