Template.adminRentalApplications.onRendered ->
  # @autorun ->
  #   if Counts.get('pendingReviewsCount')
  #     $('.review-breakdown').show()

Template.adminRentalApplications.helpers
  rentalApplications: ->
    RentalApplications.find({}, {sort: {createdAt: -1}})

  applicationFullName: ->
    if @fields.fullName then @fields.fullName else ''

  applicationApartmentName: ->
    if @fields.apartmentName then @fields.apartmentName else ''

Template.adminRentalApplications.events
  "click .delete-application": (event, template) ->
    event.stopPropagation()
    event.preventDefault()

    appId = @_id

    swal
      title: "Delete Application?"
      text: "Are you sure you want to permanently delete this rental application?"
      type: "warning"
      confirmButtonColor: "#4588fa"
      confirmButtonText: "Delete"
      closeOnConfirm: false
      showCancelButton: true
      animation: "slide-from-top"
      , (isConfirm) ->
        if isConfirm
          RentalApplications.remove(appId)
          swal
            title: "Application Deleted"
            text: "That rental application has been deleted successfully."
            type: "success"
            confirmButtonColor: "#4588fa"