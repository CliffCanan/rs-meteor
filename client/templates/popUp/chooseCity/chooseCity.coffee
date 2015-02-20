Template.chooseCity.helpers
#  helper: ->

Template.chooseCity.rendered = ->
  form = @$("form")
  form.formValidation(
    framework: 'bootstrap'
    fields:
      city:
        validators:
          notEmpty:
            message: 'Please enter city name'
  ).on("success.form.fv", grab encapsulate (event) ->
      $('#chooseCityPopup').modal('hide')
  )

Template.chooseCity.events
  "click .save-button": (event, template) ->
    form = template.$('form').serializeFormJSON()
    if form.city isnt '' or null or undefined
      UserLists.update(@.userList._id, {$set: {cityId: form.city}})