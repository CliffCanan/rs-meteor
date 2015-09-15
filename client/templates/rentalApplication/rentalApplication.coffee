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
          file.canUserView = true
          if Security.canOperateWithBuilding()
            file.isUploadedByAdmin = true if Security.canOperateWithBuilding()
            file.canUserView = false

          insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
            RentalApplications.update(instance.data._id, {$addToSet: {documents: insertedDocument}})

            fields = {}
            fields.canUserView = true
            if Security.canOperateWithBuilding()
              fields.isUploadedByAdmin = true
              fields.canUserView = false

            RentalApplicationDocuments.update result._id, {$set: fields}

        previewTemplate : '<div style="display:none"></div>'

Template.rentalApplication.helpers
  canAccess: ->
    return true if Security.canOperateWithBuilding()
    @accessToken and Session.equals('rentalApplicationAccessToken', @accessToken)
  getDatePickerDateMoveInDate: ->
    if @fields.moveInDate
      moment(@fields.moveInDate).format("MM/DD/YYYY")
  getDatePickerDateDateOfBirth: ->
    if @fields.dateOfBirth
      moment(@fields.dateOfBirth).format("MM/DD/YYYY")
  dateOfBirthOptions: ->
    yearRange: '-100:-17'
    maxDate: '-17y'
  documents: ->
    data = Template.instance().data
    rentalApplication = RentalApplications.findOne(data._id)

    result = []
    if rentalApplication.documents
      for document in rentalApplication.documents
        loadedDocument = document.getFileRecord()
        result.push(loadedDocument) if loadedDocument instanceof FS.File

    result

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
    canUserView = $(event.target).prop('checked')
    RentalApplicationDocuments.update @_id, {$set: {canUserView: canUserView}}

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

    fields =
      password: template.$('#rental-application-password-form').find('#password').val()
      hasPassword: true
      fields: $('#rental-application-form').serializeFormJSON()

    $jSignature = template.$('#signature')
    if $jSignature.jSignature('isModified')
      fields.signature = 
        base30: $jSignature.jSignature('getData', 'base30')
        svgbase64: $jSignature.jSignature('getData', 'svgbase64')

    RentalApplications.update template.data._id,
      $set: fields
      , (err, result) ->
        template.$("#rental-application-password").modal('toggle')

  "submit #rental-application-save-revision-form": (event, template) ->
    event.preventDefault()

    fields =
      isNewRevision: true
      updateNote: $('#updateNote').val()
      fields: $('#rental-application-form').serializeFormJSON()

    dateFields = ['moveInDate', 'dateOfBirth']

    for fieldName in dateFields
      fields.fields[fieldName] = new Date(fields.fields[fieldName])

    $jSignature = template.$('#signature')
    if $jSignature.jSignature('isModified')
      fields.signature = 
        base30: $jSignature.jSignature('getData', 'base30')
        svgbase64: $jSignature.jSignature('getData', 'svgbase64')

    RentalApplications.update template.data._id,
      $set: fields
      , (err, result) ->
        window.open "#{Router.path('rentalApplication', {id: template.data._id})}/download"
        template.$("#rental-application-save-revision").modal('toggle')

  "click .revert-rental-application": (event, template) ->
    Meteor.call 'revertRentalApplication', @_id if confirm "Are you sure you want to revert to '#{@updateNote}'?"

