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
        console.log("Delete Application Swal -> callback reached")
        console.log(appId)
        if isConfirm
          RentalApplications.remove(appId)
          console.log("Delete Application Swal -> isConfirm was TRUE")
          swal
            title: "Application Deleted"
            text: "That rental application has been deleted successfully."
            type: "success"
            confirmButtonColor: "#4588fa"