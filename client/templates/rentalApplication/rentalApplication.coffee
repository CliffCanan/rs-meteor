Template.rentalApplication.onRendered ->
  instance = @
  Tracker.autorun ->
    if Security.canOperateWithBuilding() or (instance.data.accessToken and Session.equals('rentalApplicationAccessToken', instance.data.accessToken))
      instance.$('#signature').jSignature()

      if instance.data.signature
        signatureData = "data:#{instance.data.signature.base30.join(',')}"
        $('#signature').jSignature('setData', signatureData)

      Dropzone.autoDiscover = false
      dropzone = new Dropzone '.dropzone.dropzone-user',
        accept: (file, done) ->
          insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
            RentalApplications.update(instance.data._id, {$addToSet: {documents: insertedDocument}})

        previewTemplate : '<div style="display:none"></div>'

      if $('.dropzone.dropzone-admin').size()
        dropzone = new Dropzone '.dropzone.dropzone-admin',
          accept: (file, done) ->
            insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
              RentalApplications.update(instance.data._id, {$addToSet: {documentsFromAdmin: insertedDocument}})

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
  documentsFromAdmin: ->
    data = Template.instance().data
    rentalApplication = RentalApplications.findOne(data._id)

    result = []
    if rentalApplication.documentsFromAdmin
        for document in rentalApplication.documentsFromAdmin
          loadedDocument = document.getFileRecord()
          result.push(loadedDocument) if loadedDocument instanceof FS.File

    result
  showDocumentsFromAdmin: ->
    data = Template.instance().data
    rentalApplication = RentalApplications.findOne(data._id)

    result = []
    if rentalApplication.documentsFromAdmin
        for document in rentalApplication.documentsFromAdmin
          loadedDocument = document.getFileRecord()
          result.push(loadedDocument) if loadedDocument instanceof FS.File

    result

    Security.canOperateWithBuilding() or result.length
  rentalApplicationRevisions: ->
    data = Template.instance().data
    revisions = RentalApplicationRevisions.find({parentId: data._id}, {sort: {revisionSavedAt: -1}}).fetch()

    index = 0
    _.map revisions, (item) ->
      item.index = index
      index++

    revisions

  isFirstItem: (doc) ->
    doc.index is 0

  rentalApplicationRevisionsCount: ->
    data = Template.instance().data
    RentalApplicationRevisions.find({parentId: data._id}).count()
  isSelected: (value) ->
    'selected' if @documentType is value

Template.rentalApplication.events
  "change .document-type": (event, template) ->
    documentType = $(event.target).val()
    if documentType
      RentalApplicationDocuments.update @_id, {$set: {documentType: documentType}}

  "change .shared-with-user": (event, template) ->
    isSharedWithUser = $(event.target).prop('checked')
    RentalApplicationDocuments.update @_id, {$set: {isSharedWithUser: isSharedWithUser}}

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
    if @hasPassword
      template.$("#rental-application-save-revision").modal('toggle')
    else
      template.$("#rental-application-password").modal('toggle')

  "submit #rental-application-password-form": (event, template) ->
    event.preventDefault()

    context = @
    RentalApplications.update template.data._id,
      $set: 
        password: template.$('#rental-application-password-form').find('#password').val()
        hasPassword: true
        fields: $('#rental-application-form').serializeFormJSON()
      , (err, result) ->
        template.$("#rental-application-password").modal('toggle')
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

  "submit #rental-application-save-revision-form": (event, template) ->
    event.preventDefault()

    fields =
      isNewRevision: true
      updateNote: $('#updateNote').val()
      fields: $('#rental-application-form').serializeFormJSON()

    $jSignature = template.$('#signature')
    if $jSignature.jSignature('isModified')
      fields.signature = 
        base30: $jSignature.jSignature('getData', 'base30')
        svgbase64: $jSignature.jSignature('getData', 'svgbase64')

    RentalApplications.update template.data._id,
      $set: fields
      , (err, result) ->
        template.$("#rental-application-save-revision").modal('toggle')

  "click .revert-rental-application": (event, template) ->
    Meteor.call 'revertRentalApplication', @_id if confirm "Are you sure you want to revert to '#{@updateNote}'?"

