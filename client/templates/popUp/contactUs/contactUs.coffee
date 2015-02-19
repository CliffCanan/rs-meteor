Template.contactUs.helpers
  serverError: ->
    Session.get("serverError")

Template.contactUs.rendered = ->
  Session.set("serverError", false)
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
      json = form.serializeFormJSON()
      json.yes = json.tourOption is "yes"
      json.no = json.tourOption is "no"
      json.notSure = json.tourOption is "notSure"
      window.localStorage['userToken'] = {
        type: 'fruit',
        color: 'yellow'
      }

      ContactUsRequests.insert(json, callback = (error, id) ->
        if error
           Session.set("serverError", true)
        else
          Session.set("serverError", false)

          form.trigger('reset')
          form.data('formValidation').resetForm()
          $('#contactUsPopup').modal('hide')
          $('#messageSentPopup').modal('show')
      )
  )


Template.contactUs.events
  "change .tour-date": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsTourDate'
  "change .move-in-data": grab encapsulate (event, template) ->
    template.$('form').formValidation 'revalidateField', 'contactUsMoveInDate'
