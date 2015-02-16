Template.header.helpers

Template.header.rendered = ->

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    cl "click .contact-us"
    cl $('#contactUsPopup').val()
    cl $('#contactUsPopup').modal()
    $('#contactUsPopup').modal('show')
