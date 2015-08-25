Template.reviewForm.onRendered ->
  instance = @
  $('#review-form-modal').on("shown.bs.modal", ->
    if instance.data
      data = instance.data.defaults
      console.log data
      instance.$('#body').val(data.body)
      instance.$("#renter-persona").val(data.renterPersona)
      instance.$("input[name='totalRating'][value='#{data.totalRating}']").prop('checked', true)

      for item in data.reviewItems
        instance.$("input[name='#{item.label.toLowerCase()}'][value='#{item.score}']").prop('checked', true)

      if data.isAnonymousReview
        instance.$('#anonymous-review').prop('checked', true)
      else
        instance.$('#anonymous-review').prop('checked', false)
  )

  form = @$("form")
  form.formValidation(
    framework: 'bootstrap'
    fields:
      title:
        validators:
          notEmpty:
            message: 'Please enter a title for your review'
      body:
        validators:
          notEmpty:
            message: 'Please enter a review'
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
      renterPersona:
        validators:
          notEmpty:
            message: 'Please select an option'
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

Template.reviewForm.helpers
  modalTitle: ->
    if Template.instance().data.title
      'Editing a review'
    else
      'Leave a new review'

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
