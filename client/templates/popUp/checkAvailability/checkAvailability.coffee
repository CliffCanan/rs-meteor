Template.checkAvailability.helpers
  serverError: ->
    Session.get("serverError")
  propertyName: ->
    if Session.get("currentUnit")
      return Session.get("currentUnit").name

Template.checkAvailability.rendered = ->
  form = @$("form")
  cl "in ChAv", Session.get("currentUnit")
  if Session.get("currentUnit")
    building = Session.get("currentUnit")
  else
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
      $('#checkAvailabilityPopup').modal('hide')
      json = form.serializeFormJSON()
      json.cityName = building.city
      json.cityId = building.cityId
      json.buildingName = building.name
      json.buildingId = building._id
      cl Session.get("currentUnit")
      if Session.get("currentUnit")
        building = Session.get("currentUnit")
      cl "success", building
      json.link = building.cityId+"/"+building.neighborhoodSlug+"/"+building.slug
      CheckAvailabilityRequests.insert(json, callback = (error, id) ->
          if error
            Session.set("serverError", true)
          else
            Session.set("serverError", false)
            form.trigger('reset')
            form.data('formValidation').resetForm()
            $('#messageSentPopup').modal('show')
      )
  )

Template.checkAvailability.events
  "change .moveInData-moveInDate-editor": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'moveInDate'
