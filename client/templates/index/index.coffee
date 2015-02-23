Template.index.helpers

Template.index.rendered = ->

Template.index.events
  "click .contact-us": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('show')