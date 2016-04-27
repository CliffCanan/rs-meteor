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
      showCancelButton: true
      animation: "slide-from-top"
      , (isConfirm) ->
        if isConfirm
          RentalApplications.remove(appId)

          toastr.options =
            "closeButton": true,
            "newestOnTop": true,
            "positionClass": "toast-top-right",
            "progressBar": true,
            "timeOut": "4000",

          toastr.success('Application Deleted Successfully')
