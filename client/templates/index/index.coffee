Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->

Template.index.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')