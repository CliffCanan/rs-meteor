Template.rentalApplication.onRendered ->
  instance = @
  Tracker.autorun ->
    if Security.canOperateWithBuilding() or (instance.data.accessToken and Session.equals('rentalApplicationAccessToken', instance.data.accessToken))
      instance.$('#signature').jSignature()

      Dropzone.autoDiscover = false
      dropzone = new Dropzone '.dropzone',
        accept: (file, done) ->
          insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
            RentalApplications.update(instance.data._id, {$addToSet: {documents: insertedDocument}})

        previewTemplate : '<div style="display:none"></div>'

Template.rentalApplication.helpers
  canAccess: ->
    return true if Security.canOperateWithBuilding()
    @accessToken and Session.equals('rentalApplicationAccessToken', @accessToken)
  documents: ->
    data = Template.instance().data
    rentalApplication = RentalApplications.findOne(data._id)

    result = []
    if rentalApplication.documents
      for document in rentalApplication.documents
        result.push(document.getFileRecord())

    result

Template.rentalApplication.events
  "submit #rental-application-access-form": (event, template) ->
    event.preventDefault()
    params =
      id: @_id
      password: template.$(event.target).find('#password').val()
    Meteor.call 'processRentalApplicationPassword', params, (err, result) ->
      if result.success
        Session.set('rentalApplicationAccessToken', result.accessToken)
      else
        alert result.message
  "submit #rental-application-form": (event, template) ->
    event.preventDefault()
    template.$("#rental-application-password").modal('toggle')

  "submit #rental-application-password-form": (event, template) ->
    event.preventDefault()
    $jSignature = template.$('#signature')
    if $jSignature.jSignature('isModified')
      signatureData = $jSignature.jSignature("getData", "svgbase64")
      signatureURI = "data:#{signatureData.join(",")}"

      file = new FS.File()
      file.attachData signatureURI
      file.name 'Signature.svg'

      insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
        RentalApplications.update template.data._id,
          $addToSet:
            documents: insertedDocument

    context = @
    RentalApplications.update template.data._id, $set: template.$('#rental-application-password-form').serializeFormJSON()


