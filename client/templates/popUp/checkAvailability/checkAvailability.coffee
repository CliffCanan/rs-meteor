Template.checkAvailability.helpers

  serverError: ->
    Session.get("serverError")

  propertyName: ->
    if Session.get("currentUnit")
      return Session.get("currentUnit").title.trim()

  currentCity: ->
    cities[@cityId].long

Template.checkAvailability.rendered = ->

  Session.set("serverError", false)

  form = @$("form")

  building = @.data.building

  $('#leadname').focus()

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
      moveInDate:
        validators:
          notEmpty:
            message: 'Please enter your target move-in date.'
          date:
            format: "MM/DD/YYYY"
            min: moment().subtract(1, "d").toDate()
            message: 'Please enter future date in MM/DD/YYYY format'
      city:
        validators:
          notEmpty:
            message: 'We need a city to search!'
  ).on("success.form.fv", grab encapsulate (event) ->
      form.find(".submit-button").prop("disabled", true)
      form.find(".submit-button i").fadeOut(200)
      form.find(".loading").fadeIn(300)

      if Session.get("currentUnit")
        building = Session.get("currentUnit")

      json = form.serializeFormJSON()
      json.cityName = if building.cityName then building cityName else 'no city name found'
      json.cityId = if building.cityId then building.cityId else 'no city id found'
      json.buildingName = if building.title then building.title else 'no Building Name found'
      json.buildingId = if building._id then building._id else 'no Building ID found'
      json.phoneNumber = if json.phoneNumber then json.phoneNumber else 'not provided'
      if not json.bedrooms
        json.bedrooms = ""
      json.link = "city/"+building.cityId+"/"+building.neighborhoodSlug+"/"+building.slug
      json.source = Session.get "utm_source"
      json.medium = Session.get "utm_medium"
      json.campaign = Session.get "utm_campaign"

      console.log(json)

      CheckAvailabilityRequests.insert(json, callback = (error, id) ->

        form.find(".submit-button").prop("disabled", false)
        form.find(".loading").hide()

        if error
          console.log(error)
          Session.set("serverError", true)
        else
          Session.set("serverError", false)

          $('#checkAvailabilityPopup').modal('hide')

          form.trigger('reset')
          form.data('formValidation').resetForm()

          unless Meteor.user() or Session.get("hasAlrdyConverted") is true
            Session.set("hasAlrdyConverted", true)

            console.log("CheckAvail Submit -> Not a Meteor User & Hasn't converted - sending analytics info")

            analytics.track "Submitted Check Availability form", {buildingId: building._id, buildingName: building.title, label: building.title}
            analytics.page title: "Submitted Check Availability Form", path: '/submit-availability-form'

            # Send FB conversion tracking to FB (Added 12/14/15 by CC)
            fbq "track", "Lead",
              content_name: "check-availability"
              content_category: "LeadGen"
              value: 25.0
              currency: "USD"
          else
            console.log("CheckAvail Submit -> NOT Triggering Analytics because this is a Meteor User or User has already submitted")

          swal
            title: "Request Submitted!"
            text: "We've received your info and we'll be in touch within 24 hours to let you know if this unit is still available."
            type: "success"
            showCancelButton: false
            confirmButtonColor: "#4588fa"
            confirmButtonText: "Great"
            #-html: true
      )
  )


Template.checkAvailability.events
  "change .moveInData-moveInDate-editor": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'moveInDate'

  "shown.bs.modal #checkAvailabilityPopup": grab encapsulate (event, template) ->
    console.log("Check Avail Popup Fired - 127")
    Session.set "hasSeenCheckAvailabilityPopup", true
    $('#leadphone').mask('(999) 999-9999')
    Meteor.setTimeout(() ->
      $('input#leadname').focus()
    , 300)

  "hidden.bs.modal #checkAvailabilityPopup": grab encapsulate (event, template) ->
    $("#checkAvailabilityPopup form").formValidation "resetForm", true

  "hidden.bs.modal #contactUsPopup": grab encapsulate (event, template) ->
    $("#contactUsPopup form").formValidation "resetForm", true
