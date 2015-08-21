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
