Template.adminReviews.onRendered ->
  @autorun ->
    if Counts.get('pendingReviewsCount')
      $('.review-breakdown').show()

Template.adminReviews.helpers
  buildingReviews: ->
    BuildingReviews.find({isPublished: false})
  defaults: ->
    Session.get('reviewFormDefaults')
