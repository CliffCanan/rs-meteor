Template.contactUs.helpers
#  helper: ->

Template.contactUs.rendered = ->
  form = @$("form")
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
      bedrooms:
        validators:
          notEmpty:
            message: 'Please enter number of bedrooms'
      contactUsTourDate:
        validators:
          date:
            format: "MM/DD/YYYY"
            min: moment().subtract(1, "d").toDate()
            message: 'Please enter future date in MM/DD/YYYY format'
      contactUsMoveInDate:
        validators:
          date:
            format: "MM/DD/YYYY"
            min: moment().subtract(1, "d").toDate()
            message: 'Please enter future date in MM/DD/YYYY format'
       city:
         validators:
           notEmpty:
             message: 'For now we need city!'
  ).on("success.form.fv", grab encapsulate (event) ->
      $('#contactUsPopup').modal('hide')
      json = form.serializeFormJSON()
      json.yes = json.tourOption is "yes"
      json.no = json.tourOption is "no"
      json.notSure = json.tourOption is "notSure"
      ContactUsRequests.insert(json)
      form.trigger('reset')
  )


Template.contactUs.events
  "click .cancel-button": grab encapsulate (event, template) ->
    $('#contactUsPopup').modal('hide')
  "change .tour-date": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsTourDate'
  "change .move-in-data": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsMoveInDate'
