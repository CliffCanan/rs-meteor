Template.checkAvailability.helpers
#  helper: ->

Template.checkAvailability.rendered = ->

Template.checkAvailability.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#chechAvailabilityPopup').modal('show')
  "click .submit-button": grab encapsulate (event, template) ->
    $('#chechAvailabilityPopup').modal('hide')
    $('#chechAvailabilityMessageSentPopup').modal('show')
  "click .continue-browsing": grab encapsulate (event, template) ->
    $('#chechAvailabilityMessageSentPopup').modal('hide')
