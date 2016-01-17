Template.reviewForm.onRendered ->
  instance = @
  $('#review-form-modal').on("shown.bs.modal", ->
    if instance.data and instance.data.defaults
      data = instance.data.defaults
      instance.$('#body').val(data.body)
      instance.$("#renter-persona").val(data.renterPersona)
      instance.$("input[name='totalRating'][value='#{data.totalRating}']").prop('checked', true)

      for item in data.reviewItems
        instance.$("input[name='#{item.label.toLowerCase()}'][value='#{item.score}']").prop('checked', true)

      if data.isAnonymousReview
        instance.$('#name').val('Anonymous')
        instance.$('#name').attr('disabled', 'disabled')
        instance.$('#anonymous-review').prop('checked', true)
      else
        instance.$('#name').removeAttr('disabled')
        instance.$('#anonymous-review').prop('checked', false)
  )

  form = @$("#review-form")
  form.formValidation(
    framework: 'bootstrap'
    fields:
      title:
        validators:
          notEmpty:
            message: 'Please give your review a title.'
      body:
        validators:
          notEmpty:
            message: 'Please enter your review.'
      name:
        validators:
          notEmpty:
            message: 'Please enter your name.'
      email:
        validators:
          notEmpty:
            message: 'Please enter your email address.'
          emailAddress:
            message: 'Please enter a valid email address.'
      renterPersona:
        validators:
          notEmpty:
            message: 'Please select an option from the dropdown menu.'
      totalRating:
        validators:
          notEmpty:
            message: 'Please select a number 1-10 for your overall rating.'
      noise:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
      location:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
      amenities:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
      management:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
      value:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
      quality:
        validators:
          notEmpty:
            message: 'Please leave a rating for this question.'
  ).on("success.form.fv", (event) ->
    event.preventDefault()
    success = false
    reviewObject = instance.$('#review-form').serializeFormJSON()
    # Editing an existing review
    if instance.data.defaults
      reviewObject = instance.$('#review-form').serializeFormJSON()
      reviewObject.id = instance.data.defaults._id
      Meteor.call 'updateReview', reviewObject, (err, result) ->
        if err
          alert err.reason
        else
          $('#review-form-modal').modal('hide')
          swal
            title: "Review Submitted!"
            text: "Your review has been updated and is awaiting moderation. Thank you, you're awesome!"
            type: "success"
            confirmButtonColor: "#4588fa"
            confirmButtonText: "Continue Browsing"
            animation: "slide-from-top"

    # Adding a new review
    else
      reviewObject.buildingId = Router.current().data().building._id
      Meteor.call 'insertReview', reviewObject, (err, result) ->
        if err
          alert err.reason
        else
          $('#review-form-modal').modal('hide')
          swal
            title: "Review Submitted!"
            text: "Your review is now in the queue and should appear shortly. Thank you, you're awesome!"
            type: "success"
            confirmButtonColor: "#4588fa"
            confirmButtonText: "Continue Browsing"
            animation: "slide-from-top"
  )

Template.reviewForm.helpers
  modalTitle: ->
    if Template.instance().data.defaults
      'Edit A Review'
    else
      'Write A New Review'
  submitText: ->
    if Template.instance().data.defaults
      'Save Review'
    else
      'Post Review'

Template.reviewForm.events
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
