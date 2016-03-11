Template.contactUs.helpers
  serverError: ->
    Session.get("serverError")

  cityName: ->
    if @cityId
      "to " + cities[@cityId].short

  isMobile: ->
    $(window).width() < 768

Template.contactUs.rendered = ->

  Session.set("serverError", false)

  $('i[data-toggle="popover"]').popover()

  cityId = @.data?.cityId

  form = @$("form")

  form.formValidation(
    framework: 'bootstrap'
    live: 'disabled'
    err:
      container: "tooltip"
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
#      bedrooms:
#        validators:
#          notEmpty:
#            message: 'Please select your target number of bedrooms'
      maxMonthlyRent:
        validators:
          notEmpty:
            message: "Please enter the MAX budget you're willing to pay per month."
          greaterThan:
            value: 900
            message: "Most of our units begin at $900/mo, unfortunately."
          lessThan:
            value: 5000
            message: "Most of our units are below $5,000/mo, unfortunately."
#      tourOption:
#        validators:
#          notEmpty:
#            message: 'Please select an option.'
#      contactUsMoveInDate:
#        validators:
#          notEmpty:
#            message: 'When would you like to move in?'
#          date:
#            format: "MM/DD/YYYY"
#            min: moment().subtract(1, "d").toDate()
#            message: 'Please select a date in the future!'
#      contactUsTourDate:
#        validators:
#          callback:
#            message: 'When would you like to schedule a tour?'
#            callback: (value, validator, $field) ->
#              tourValue = $("form.contact-us-form [name=\"tourOption\"]:checked").val()
#              (if (tourValue isnt "yes") then true else (value isnt ""))
#  ).on("change", "[name=\"tourOption\"]", (e) ->
#    $("form.contact-us-form").formValidation "revalidateField", "contactUsTourDate"
#  ).on("success.field.fv", (e, data) ->
#    if data.field is "contactUsTourDate"
#      tourValue = $("form.contact-us-form [name=\"tourOption\"]:checked").val()
#      if tourValue isnt "yes"
#        data.element.closest(".form-group").removeClass "has-success"
#        data.element.data("fv.icon").hide()
  ).on("success.form.fv", grab encapsulate (event) ->
      form.find(".submit-button").prop("disabled", true)
      form.find(".submit-button i").fadeOut(200)
      form.find(".loading").fadeIn(300)

      num = "no phone provided"

      json = form.serializeFormJSON()

      if json.phoneNumber
        num = json.phoneNumber.replace("(","").replace(")","").replace("-","").replace(" ","").trim()
        num = num.substring(0, 3) + "-" + num.substring(3);
        num = num.substring(0, 7) + "-" + num.substring(7);

#      json.yes = json.tourOption is "yes"
#      json.no = json.tourOption is "no"
#      json.notSure = json.tourOption is "notSure"
#      json.contactUsTourDate = if json.contactUsTourDate then json.contactUsTourDate else ''
      json.cityId = if cityId then cityId else 'no city id found'
      json.cityName = if cityId then cities[cityId].short else 'no city name found'
      json.phoneNumber = num
      json.source = Session.get "utm_source"
      json.medium = Session.get "utm_medium"
      json.campaign = Session.get "utm_campaign"

      cityNameForFB = json.cityName

      console.log(json)

      ContactUsRequests.insert(json, callback = (error, id) ->

        form.find(".submit-button").prop("disabled", false)
        form.find(".loading").hide()

        if error
          console.log(error)
          Session.set("serverError", true)
        else
          Session.set("serverError", false)

          #console.log("Contact Us Form Submitted Successfully!")

          $('#contactUsPopup').modal('hide')

          form.trigger('reset')
          form.data('formValidation').resetForm()

          unless Meteor.user() or Session.get("hasAlrdyConverted") is true
            Session.set("hasAlrdyConverted", true)

            console.log("ContactUs Submit -> Not a Meteor User - sending analytics info")

            analytics.track "Submitted Contact Us form"
            analytics.page title: "Submitted Contact Us form", path: '/submit-contact-us-form'

            #-goog_report_conversion()

            #- (Added 12/14/15 by CC)
            fbq "track", "Lead",
              content_name: "contact-us"
              content_category: "LeadGen"
              value: 30.0
              currency: "USD"
          else
            console.log("ContactUs Submit -> NOT Triggering Analytics because this is a Meteor User or User has already submitted")

          swal
            title: "Great Success!"
            text: "Good news - our team is already on the hunt to find the perfect apartment for you.<span class='show m-t-10'>We'll get right back to you and show you the best apartments for your budget and lifestyle.</span>"
            type: "success"
            showCancelButton: false
            confirmButtonColor: "#4588fa"
            confirmButtonText: "Awesome"
            html: true
      )
  )

$("#contactUsPopup").on "shown.bs.modal", ->
  console.log("CONTACT US Popup Fired - 133")
  #$("#contactUsPopup form").formValidation "resetForm", true


Template.contactUs.events

  "shown.bs.modal #contactUsPopup": grab encapsulate (event, template) ->
    Session.set "hasSeenContactUsPopup", true

    $("#contactUsPopup #leadphone").mask "(999) 999-9999", placeholder: " "
    #$("input[name=\"maxMonthlyRent\"]").mask('999?9', {placeholder:" "})

    if $(window).width() > 992
      Meteor.setTimeout(() ->
        $('input#contactUsName').focus()
      , 250)

  ###
  "change .tour-date": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsTourDate'

  "change .move-in-data": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsMoveInDate'

  "change input[name='tourOption']": (event, template) ->
    if $(event.target).val() is 'no'
      template.$('#contactUsTourDate').attr('disabled', true)
    else
      template.$('#contactUsTourDate').attr('disabled', false)
  ###

  "click #contactUsPopup .call-now": (event, template) ->
    console.log("Contact Us Call Now btn clicked")
    analytics.track "Clicked CALL NOW Btn (Contact Us)" unless Meteor.user()
    true

  "hidden.bs.modal #contactUsPopup": grab encapsulate (event, template) ->
    $("#contactUsPopup form").formValidation "resetForm", true

    $("#contactUsPopup .form-group").each (index) ->
      $(this).removeClass "has-error"  if $(this).hasClass "has-error"
      $(this).removeClass "has-success"  if $(this).hasClass "has-success"

    $("#contactUsPopup .fg-input").each (index) ->
      $(this).val('')
      $(this).closest(".fg-line").removeClass "fg-toggled"  if $(this).closest(".fg-line").hasClass "fg-toggled"
