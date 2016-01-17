Template.adminRentalApplications.onRendered ->
  # @autorun ->
  #   if Counts.get('pendingReviewsCount')
  #     $('.review-breakdown').show()

Template.adminRentalApplications.helpers
  rentalApplications: ->
    RentalApplications.find({}, {sort: {createdAt: -1}})
  applicationFullName: ->
    @fields.fullName or 'N/A'
  applicationApartmentName: ->
    @fields.apartmentName or 'N/A'

Template.adminRentalApplications.events
  "click .delete-application": (event, template) ->
    swal
      title: "Delete Application?"
      text: "Are you sure you want to delete this rental application?"
      type: "warning"
      confirmButtonColor: "#4588fa"
      confirmButtonText: "Delete"
      animation: "slide-from-top"
      , (confirm) ->
        if confirm
          RentalApplications.remove(@_id)