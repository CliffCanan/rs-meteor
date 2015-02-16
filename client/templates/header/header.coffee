Template.header.helpers

Template.header.rendered = ->

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')
