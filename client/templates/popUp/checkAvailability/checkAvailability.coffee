Template.checkAvailability.helpers

  serverError: ->
    Session.get("serverError")

  propertyName: ->
    if Session.get("currentUnit")
      return Session.get("currentUnit").title.trim()

  currentCity: ->
    cities[@cityId].long

  isBizHours: ->
    currentDate = new Date()
    day = currentDate.getUTCDay()
    # Get EST time
    hour = currentDate.getUTCHours() - 5

    # If UTC time is < 5:00am, then EST will be a day behind still
    if hour < 0
      hour += 24
      day -= 1
    # If converting hours from UTC to EST pushes the Day below 0 (i.e. it's b/t 12:00-5:00am UTC on a Sunday), need to correct the day value
    day += 7 if day < 0

    if (day is not 6 and hour > 7 and hour < 20) then true else false

  isMobile: ->
    $(window).width() < 768

Template.checkAvailability.rendered = ->

  Session.set("serverError", false)

  form = @$("form")

  building = @.data.building if @.data

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
#      bedrooms:
#        validators:
#          notEmpty:
#            message: 'Please select your target number of bedrooms'
#      moveInDate:
#        validators:
#          notEmpty:
#            message: 'Please enter your target move-in date.'
#          date:
#            format: "MM/DD/YYYY"
#            min: moment().subtract(1, "d").toDate()
#            message: 'Please select a date in the future!'
#      city:
#        validators:
#          notEmpty:
#            message: 'We need a city to search!'
  ).on("success.form.fv", grab encapsulate (event) ->
      form.find(".submit-button").prop("disabled", true)
      form.find(".submit-button i").fadeOut(200)
      form.find(".loading").fadeIn(300)

      if Session.get("currentUnit")
        building = Session.get("currentUnit")

      num = "no phone provided"

      json = form.serializeFormJSON()

      if json.phoneNumber
        num = json.phoneNumber.replace("(","").replace(")","").replace("-","").replace(" ","").trim()
        console.log(num)
        num = num.substring(0, 3) + "-" + num.substring(3);
        num = num.substring(0, 7) + "-" + num.substring(7);
        console.log(num)

      json.cityName = if building and building.cityName then building.cityName else 'no city name found'
      json.cityId = if building and building.cityId then building.cityId else 'no city id found'
      json.buildingName = if building and building.title then building.title else 'no Building Name found'
      json.buildingId = if building and building._id then building._id else 'no Building ID found'
      json.phoneNumber = num
#      if not json.bedrooms
#        json.bedrooms = ""
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
            text: "We've received your request and we'll get right back to you about this unit's availability."
            type: "success"
            showCancelButton: false
            confirmButtonColor: "#4588fa"
            confirmButtonText: "Great"
            #-html: true
      )
  )


Template.checkAvailability.events
  #"change .moveInData-moveInDate-editor": grab encapsulate (event, template) ->
  #  template.$('form').formValidation 'revalidateField', 'moveInDate'

  "shown.bs.modal #checkAvailabilityPopup": grab encapsulate (event, template) ->
    Session.set "hasSeenCheckAvailabilityPopup", true

    $('[data-toggle="popover"]').popover()
    $("#checkAvailabilityPopup #leadphone").mask "(999) 999-9999", placeholder: " "

    if $(window).width() > 992
      Meteor.setTimeout(() ->
        $('input#leadname').focus()
      , 250)

  "click #checkAvailabilityPopup .call-now": (event, template) ->
    console.log("Contact Us Call Now btn clicked")
    analytics.track "Clicked CALL NOW Btn (Check Avail)" unless Meteor.user()
    true

  "hidden.bs.modal #checkAvailabilityPopup": grab encapsulate (event, template) ->
    $("#checkAvailabilityPopup form").formValidation "resetForm", true

    $("#checkAvailabilityPopup .fg-input").each (index) ->
      $(this).val('')
      $(this).closest(".fg-line").removeClass "fg-toggled"  if $(this).closest(".fg-line").hasClass "fg-toggled"
