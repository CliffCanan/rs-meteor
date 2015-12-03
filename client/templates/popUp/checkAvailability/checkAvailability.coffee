Template.checkAvailability.helpers
  serverError: ->
    Session.get("serverError")
  propertyName: ->
    if Session.get("currentUnit")
      return Session.get("currentUnit").title

Template.checkAvailability.rendered = ->
  form = @$("form")
  building = @.data.building
  form.formValidation(
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
            min: moment().subtract(1, "d").toDate()
            message: 'Please enter future date in MM/DD/YYYY format'
      city:
        validators:
          notEmpty:
            message: 'For now we need city!'
  ).on("success.form.fv", grab encapsulate (event) ->
      form.find(".submit-button").prop("disabled", true)
      form.find(".loading").show()
#      change to Id
      if Session.get("currentUnit")
        building = Session.get("currentUnit")
      json = form.serializeFormJSON()
      json.cityName = building.city
      json.cityId = building.cityId
      json.buildingName = building.title
      json.buildingId = building._id
      if not json.bedrooms
        json.bedrooms = ""
      json.link = "city/"+building.cityId+"/"+building.neighborhoodSlug+"/"+building.slug
      CheckAvailabilityRequests.insert(json, callback = (error, id) ->
          if error
            Session.set("serverError", true)
          else
            Session.set("serverError", false)
            $('#checkAvailabilityPopup').modal('hide')
            form.trigger('reset')
            form.data('formValidation').resetForm()
            $('#messageSentPopup').modal('show')
            form.find(".submit-button").prop("disabled", false)
            form.find(".loading").hide()
            analytics.track "Submitted Check Availability form", {buildingId: building._id, buildingName: building.title, label: building.title}
            analytics.page title: "Submitted Check Availability form", path: '/submit-availability-form'
      )
  )

Template.checkAvailability.events
  "change .moveInData-moveInDate-editor": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'moveInDate'
