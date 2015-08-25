Template.reviewForm.onRendered ->
  form = @$("form")
  instance = @
  form.formValidation(
    framework: 'bootstrap'
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
      totalRating:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      noise:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      location:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      amenities:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      management:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      value:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
      quality:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question'
  ).on("success.form.fv", (event) ->
    reviewObject = instance.$('#review-form').serializeFormJSON()
    reviewObject.buildingId = Router.current().data().building._id

    Meteor.call 'insertReview', reviewObject, (err, result) ->
      if err
        alert err.reason
      else
        $('#review-form-modal').modal('hide')
        $('#review-sent-modal').modal('show')
  )

Template.reviewForm.events
  "click #post-review": (event, template) ->
    reviewObject = template.$('#review-form').serializeFormJSON()
    reviewObject.buildingId = Router.current().data().building._id

    Meteor.call 'insertReview', reviewObject, (err, result) ->
      if err
        alert err.reason
      else
        $('#review-form-modal').modal('hide')
        $('#review-sent-modal').modal('show')

  "keyup #name": (event, target) ->
    $name = $(event.target)
    $name.data('name', $name.val())

  "click #anonymous-review": (event, template) ->
    $checkbox = $(event.target)
    $name = template.$('#name')

    if $('#anonymous-review:checked').size()
      $name.val('Anonymous')
      $name.attr('disabled', 'disabled')
    else
      $name.val($name.data('name'))
      $name.removeAttr('disabled')
