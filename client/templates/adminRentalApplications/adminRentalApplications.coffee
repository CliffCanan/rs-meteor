Template.adminRentalApplications.onRendered ->
  # @autorun ->
  #   if Counts.get('pendingReviewsCount')
  #     $('.review-breakdown').show()

Template.adminRentalApplications.helpers
  rentalApplications: ->
    RentalApplications.find({}, {sort: {createdAt: -1}})

Template.adminRentalApplications.events
  "click .delete-application": (event, template) ->
    RentalApplications.remove(@_id) if confirm 'Are you sure you want to delete this rental application?'