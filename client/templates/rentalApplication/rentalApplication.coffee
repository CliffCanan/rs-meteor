saveOtherDocumentType = ''

Template.rentalApplication.onRendered ->
  instance = @
  $('#partner-ssn').mask('999-99-9999')
  $('#social-security-number').mask('999-99-9999')

  $('#phone-number').mask('999-999-9999')
  $('#current-landlord-phone-number').mask('999-999-9999')
  $('#previous-landlord-phone-number').mask('999-999-9999')
  $('#first-reference-phone-number').mask('999-999-9999')
  $('#second-reference-phone-number').mask('999-999-9999')
  $('#first-emergency-contact-phone-number').mask('999-999-9999')
  $('#second-emergency-contact-phone-number').mask('999-999-9999')

  if @data.field
    $('#is-student').val(@data.fields.isStudent).trigger('change')
    $('#has-partner-roommate').val(@data.fields.hasPartnerRoommate).trigger('change')
    $('#has-pets').val(@data.fields.hasPets).trigger('change')
    $('#current-address-ownership').val(@data.fields.currentAddressOwnership).trigger('change')
    $('#current-address-duration').val(@data.fields.currentAddressDuration).trigger('change')
    $('#previous-address-ownership').val(@data.fields.previousAddressOwnership).trigger('change')
    $('#previous-address-duration').val(@data.fields.previousAddressDuration).trigger('change')
    $('#has-filed-for-bankruptcy').val(@data.fields.hasFiledForBankruptcy).trigger('change')
    $('#has-been-evicted').val(@data.fields.hasBeenEvicted).trigger('change')
    $('#has-refused-to-pay-rent').val(@data.fields.hasRefusedToPayRent).trigger('change')
    $('#has-violated-or-broken-any-lease-agreement').val(@data.fields.hasViolatedOrBrokenAnyLeaseAgreement).trigger('change')
    $('#has-a-criminal-history').val(@data.fields.hasACriminalHistory).trigger('change')
    $('#has-pending-case').val(@data.fields.hasPendingCase).trigger('change')
    $('#is-registered-sex-offender').val(@data.fields.isRegisteredSexOffender).trigger('change')

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
    if @fields and @fields.moveInDate
      moment(@fields.moveInDate).format("MM/DD/YYYY")
  getDatePickerDateDateOfBirth: ->
    if @fields and @fields.dateOfBirth
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
  documentTypeClass: ->
    classes = [@documentType]
    classes.push 'other' if @isOther is true
    classes.join ' '
  isSelected: (value) ->
    return 'selected' if @isOther is true and value is 'Other'
    return 'selected' if @documentType is value

Template.rentalApplication.events
  "change #is-student": (event, template) ->
    if $(event.target).val() is 'Yes'
      template.$('.student-wrapper').show()
    else
      template.$('.student-wrapper').hide()

  "change #has-pets": (event, template) ->
    if $(event.target).val() is 'Yes'
      template.$('.pets-wrapper').show()
    else
      template.$('.pets-wrapper').hide()

  "change #has-partner-roommate": (event, template) ->
    template.$('.partner-wrapper').hide()
    template.$('.roommate-wrapper').hide()
    if $(event.target).val() is 'I have a partner'
      template.$('.partner-wrapper').show()
    else if $(event.target).val() is 'I have a roommate'
      template.$('.roommate-wrapper').show()

  "change #previous-address-duration": (event, template) ->
    hideIfValues = ['N/A', '12 months', '12+ months']
    if hideIfValues.indexOf($(event.target).val()) > -1
      template.$('.previous-address-wrapper').hide()
    else
      template.$('.previous-address-wrapper').show()

  "click #no-to-all-criminal-history": (event, template) ->
    template.$('.criminal-history-input-wrapper select').val('No')

  "change .criminal-history-input-wrapper select": (event, template) ->
    showExplanationWrapper = false
    $('.criminal-history-input-wrapper select').each ->
      showExplanationWrapper = true if $(@).val() == 'Yes'

    if showExplanationWrapper
      $('.criminal-history-explanation-wrapper').show()
    else
      $('.criminal-history-explanation-wrapper').hide()

  "change .document-type": (event, template) ->
    documentType = $(event.target).val()
    if documentType
      modifiers = {}
      if documentType is 'Other'
        modifiers.$set = isOther: true
        modifiers.$unset = documentType: 1
      else
        modifiers.$set = documentType: documentType
        modifiers.$unset = isOther: 1

      RentalApplicationDocuments.update @_id, modifiers

  "change .shared-with-user": (event, template) ->
    canUserView = $(event.target).prop('checked')
    RentalApplicationDocuments.update @_id, {$set: {canUserView: canUserView}}

  "keyup .document-type-other": (event, template) ->
    if saveOtherDocumentType
      Meteor.clearTimeout saveOtherDocumentType

    $siblings = $(event.target).siblings('i.fa')
    $siblings.hide()
    $siblings.filter('.fa-spinner').show()

    id = @_id
    saveOtherDocumentType = Meteor.setTimeout ->
      documentType = $(event.target).val()
      RentalApplicationDocuments.update id, {$set: {documentType: documentType}}, {}, (err, result) ->
        $siblings.hide()
        $siblings.filter('.fa-check-circle').show()
      Meteor.clearTimeout saveOtherDocumentType
    , 1500

  "click .delete-document": (event, template) ->
    if confirm 'Are you sure you want to delete this document?'
      RentalApplications.update(template.data._id, { $pull: { documents: {"EJSON$value.EJSON_id": @_id } }})
      RentalApplicationDocuments.remove(@_id)

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
        location.href = "#{Router.path('rentalApplication', {id: template.data._id})}/download"

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
        location.href = "#{Router.path('rentalApplication', {id: template.data._id})}/download"
        template.$("#rental-application-save-revision").modal('toggle')

  "click .revert-rental-application": (event, template) ->
    Meteor.call 'revertRentalApplication', @_id if confirm "Are you sure you want to revert to '#{@updateNote}'?"

