Template.checkAvailability.helpers
#  helper: ->

Template.checkAvailability.rendered = ->
#  form = @$("form")
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
            message: 'Please enter Move-in date in MM/DD/YYYY format'
          date:
            format: "MM/DD/YYYY"
          callback:
            message: 'Please enter future date in MM/DD/YYYY format',
            callback: (value, validator) ->
              m = new moment(value, 'MM/DD/YYYY', true)
              if !m.isValid()
                return false
              m.isAfter(moment().day(-1))
  ).on("success.form.fv", grab encapsulate (event) ->
      $('#checkAvailabilityPopup').modal('hide')
      newRequest = {
        name: document.getElementsByClassName("moveInData-name-editor")[0].value
        email: document.getElementsByClassName("moveInData-email-editor")[0].value
        moveInDate: document.getElementsByClassName("moveInData-moveInDate-editor")[0].value
        question: document.getElementsByClassName("moveInData-question-editor")[0].value
        propertyId: 1
      }
      CheckAvailabilityRequests.insert(newRequest)
      $('#checkAvailabilityMessageSentPopup').modal('show')

  )


Template.checkAvailability.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('show')
  "click .cancel-button": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('hide')
  "click .continue-browsing": grab encapsulate (event, template) ->
    $('#checkAvailabilityMessageSentPopup').modal('hide')
  "change .moveInData-moveInDate-editor": grab encapsulate (event, template) ->
    $('form').formValidation 'revalidateField', 'moveInDate'
