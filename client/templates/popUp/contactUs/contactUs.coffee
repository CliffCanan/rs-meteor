Template.contactUs.helpers
  serverError: ->
    Session.get("serverError")
  cityName: ->
    if @cityId
      "to " + cities[@cityId].short

Template.contactUs.rendered = ->
  Session.set("serverError", false)

  cityId = @.data?.cityId
  form = @$("form")
  form.formValidation(
    framework: 'bootstrap'
    live: 'disabled'
    icon:
      valid: "fa fa-check"
      invalid: "fa fa-remove"
      validating: "fa fa-refresh"
    fields:
      name:
        validators:
          notEmpty:
            message: 'Please enter your name :-)'
      email:
        validators:
          notEmpty:
            message: 'Please enter your email address.'
          emailAddress:
            message: 'Please enter a valid email address!'
      bedrooms:
        validators:
          notEmpty:
            message: 'Please select your target number of bedrooms'
      maxMonthlyRent:
        validators:
          notEmpty:
            message: 'Please enter the MOST you\'re willing to pay per month.'
          greaterThan:
            value: 1000
            message: "Most of our units begin at $1,000/mo, unfortunately."
          lessThan:
            value: 5000
            message: "Most of our units are below $5,000/mo, unfortunately."
      tourOption:
        validators:
          notEmpty:
            message: 'Please select an option.'
      contactUsTourDate:
        validators:
          callback:
            message: 'When would you like to schedule a tour?'
            callback: (value, validator, $field) ->
              channel = form.find("[name=\"tourOption\"]:checked").val()
              (if (channel isnt "yes") then true else (value isnt ""))
      contactUsMoveInDate:
        validators:
          notEmpty:
            message: 'When would you like to move in?'
          date:
            format: "MM/DD/YYYY"
            min: moment().subtract(1, "d").toDate()
            message: 'Please select a date in the future!'
  ).on("success.form.fv", grab encapsulate (event) ->
      form.find(".submit-button").prop("disabled", true)
      form.find(".submit-button i").fadeOut(200)
      form.find(".loading").fadeIn(300)

      json = form.serializeFormJSON()
      json.yes = json.tourOption is "yes"
      json.no = json.tourOption is "no"
      json.notSure = json.tourOption is "notSure"
      json.cityId = if cityId then cityId else ''
      json.cityName = if cityId then cities[cityId].short else ''

      cityNameForFB = json.cityName

      ContactUsRequests.insert(json, callback = (error, id) ->
        if error
           Session.set("serverError", true)
        else
          Session.set("serverError", false)
          form.trigger('reset')
          form.data('formValidation').resetForm()
          $('#contactUsPopup').modal('hide')
          $('#messageSentPopup').modal('show')

          analytics.track "Submitted Contact Us form"
          analytics.page title: "Submitted Contact Us form", path: '/submit-contact-us-form'

          form.find(".submit-button").prop("disabled", false)
          form.find(".loading").hide()

          # (Added 12/14/15 by CC)
          fbq "track", "Lead",
            content_name: cityNameForFB.replace(' ','_')
            content_category: "ContactUs"
            value: 25.0
            currency: 'USD'
      )
  )


Template.contactUs.events
  "change .tour-date": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsTourDate'

  "change .move-in-data": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsMoveInDate'

  "change input[name='tourOption']": (event, template) ->
    if $(event.target).val() is 'no'
      template.$('#contactUsTourDate').attr('disabled', true)
    else
      template.$('#contactUsTourDate').attr('disabled', false)

  $("#contactUsPopup").on "hidden.bs.modal", ->
    $("#contactUsPopup form").formValidation "resetForm", true