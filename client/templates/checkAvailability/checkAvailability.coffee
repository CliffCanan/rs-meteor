Template.checkAvailability.helpers
#  helper: ->

Template.checkAvailability.rendered = ->
  @$("form").formValidation(
    framework: 'bootstrap'
    live: 'disabled'
    fields:
      name:
        validators:
          notEmpty:
            message: 'Please enter your name'
      email:
        validators:
          notEmpty:
            message: 'Please enter your email address'
          emailAddress:
            message: 'Please enter a valid email address'
      moveInDate:
        validators:
          notEmpty:
            message: 'Please enter Move-in date'
          date:
            format: 'MM/DD/YYYY'
            message: 'Please enter date in MM/DD/YYYY format'
  ).on("success.form.fv", grab encapsulate (event) ->
      $('#chechAvailabilityPopup').modal('hide')
      $('#chechAvailabilityMessageSentPopup').modal('show')
  )

Template.checkAvailability.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#chechAvailabilityPopup').modal('show')
  "click .cancel-button": grab encapsulate (event, template) ->
    $('#chechAvailabilityPopup').modal('hide')
  "click .continue-browsing": grab encapsulate (event, template) ->
    $('#chechAvailabilityMessageSentPopup').modal('hide')