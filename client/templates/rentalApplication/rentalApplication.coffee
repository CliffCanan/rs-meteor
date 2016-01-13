saveOtherDocumentType = ''

Template.rentalApplication.onRendered ->
  instance = @

  unless Security.canOperateWithBuilding() or not @data.hasPassword
    unless @data.accessToken and Session.equals('rentalApplicationAccessToken', @data.accessToken)
      appId = @data._id

      swal
        title: "Password Required"
        text: "Please enter the password for this application to continue:"
        type: "input"
        inputPlaceholder: "Enter password here"
        inputType: "password"
        confirmButtonColor: "#4588fa"
        confirmButtonText: "Continue"
        closeOnConfirm: false
        allowEscapeKey: false
        allowOutsideClick: false
        animation: "slide-from-top"
        , (inputValue) ->
          return false  if inputValue is false

          if inputValue is ""
            swal.showInputError "Please enter the password you entered when you first created this application."
            return false
            
          params =
            id: appId
            password: inputValue

          Meteor.call 'processRentalApplicationPassword', params, (err, result) ->
           if result.success
             swal.close()
             Session.set('rentalApplicationAccessToken', result.accessToken)
             instance.$('.access-wrapper').removeClass('hidden')
             return true
           else
             alert result.message
    else
      $('.access-wrapper').removeClass('hidden')
  
  $('#rentAmnt').mask('9,999')
  $('#partner-ssn').mask('999-99-9999')
  $('#social-security-number').mask('999-99-9999')
  $('#phone-number').mask('(999) 999-9999')
  $('#current-landlord-phone-number').mask('(999) 999-9999')
  $('#previous-landlord-phone-number').mask('(999) 999-9999')
  $('#first-reference-phone-number').mask('(999) 999-9999')
  $('#second-reference-phone-number').mask('(999) 999-9999')
  $('#first-emergency-contact-phone-number').mask('(999) 999-9999')
  $('#second-emergency-contact-phone-number').mask('(999) 999-9999')

  $('input.num-max-2').mask('99')
  $('input.num-max-4').mask('9999')
  $('input.num-max-5').mask('99999')

  $('[data-toggle="tooltip"]').tooltip()

  if @data.fields
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
    if Security.canOperateWithBuilding() or (instance.data.accessToken and Session.equals('rentalApplicationAccessToken', instance.data.accessToken)) or not instance.data.hasPassword
      instance.$('#signature').not('.processed').jSignature()
      instance.$('#signature').addClass('processed')

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
    return true if Security.canOperateWithBuilding() or not @hasPassword
    @accessToken and Session.equals('rentalApplicationAccessToken', @accessToken)

  getDatePickerDateMoveInDate: ->
    if @fields and @fields.moveInDate
      moment(@fields.moveInDate).format("MM/DD/YYYY")

  getDatePickerDateDateOfBirth: ->
    if @fields and @fields.dateOfBirth
      moment(@fields.dateOfBirth).format("MM/DD/YYYY")

  dateOfBirthOptions: ->
    #yearRange: '-100:-17'
    dateFormat: "m/d/yy"
    minDate: '-100y'
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
      template.$('.student-wrapper').slideDown()
      template.$('.hide-non-student').show()
    else
      template.$('.student-wrapper').slideUp()
      template.$('.hide-non-student').hide()

  "click .pet-box": (event, template) ->
    if $(event.target).hasClass('selected')
      $(event.target).removeClass('selected')

      if $(event.target).attr('id') is 'catBox'
        template.$('#cats-table-wrapper').slideUp()
      else if $(event.target).attr('id') is 'dogBox'
        template.$('#dogs-table-wrapper').slideUp()
      else if $(event.target).attr('id') is 'otherBox'
        template.$('#otherpet-wrapper').slideUp()

    else
      $(event.target).addClass('selected')

      if $(event.target).attr('id') is 'catBox'
        template.$('#cats-table-wrapper').slideDown()
      else if $(event.target).attr('id') is 'dogBox'
        template.$('#dogs-table-wrapper').slideDown()
      else if $(event.target).attr('id') is 'otherBox'
        template.$('#otherpet-wrapper').slideDown()

      if $(event.target).attr('id') is 'noPetsBox'
        template.$('.pet-box:not(#noPetsBox)').removeClass('selected')
        template.$('#cats-table-wrapper').slideUp()
        template.$('#dogs-table-wrapper').slideUp()
        template.$('#otherpet-wrapper').slideUp()
      else
        template.$('.pet-box#noPetsBox').removeClass('selected')

  "click #addCat": (event, template) ->
    rowNum = $("#catsTable tbody tr").length + 1
    if rowNum > 5
      swal
        title: ""
        text: "Oh my, that's a lot of cats. Since most buildings don't allow that many feline roommates, it might be best if we spoke with you to discuss your situation. Please email team@rentscene.com or call (267) 463-2426. Thanks!"
        type: "warning"
        showCancelButton: false
        confirmButtonColor: "#4588fa"
        confirmButtonText: "Ok"
    else
      template.$('#catsTable tbody').append("<tr><td>" + rowNum + "</td><td><input class='form-control' type='text' name='cat" + rowNum + "Name' /></td><td><input class='form-control' type='text' name='cat" + rowNum + "Weight' /></td><td><input class='form-control' type='text' name='cat" + rowNum + "Age' /></td><td><input class='form-control' type='text' name='cat" + rowNum + "Color' /></td><td><select class='form-control' name='cat" + rowNum + "Neutered'><option value='Yes'>Yes</option><option value='No'>No</option></select></td> </tr>");

  "click #addDog": (event, template) ->
    rowNum = $("#dogsTable tbody tr").length + 1
    if rowNum > 5
      swal
        title: ""
        text: "Wow, that's a lot of dogs. Since most buildings don't allow that many canine companions, it might be best if we spoke with you to discuss your situation. Please email team@rentscene.com or call (267) 463-2426. Thanks!"
        type: "warning"
        showCancelButton: false
        confirmButtonColor: "#4588fa"
        confirmButtonText: "Ok"
    else
      template.$('#dogsTable tbody').append("<tr><td>" + rowNum + "</td><td><input class='form-control' type='text' name='dog" + rowNum + "Name' /></td><td><input class='form-control' type='text' name='dog" + rowNum + "Breed' /></td><td><input class='form-control' type='text' name='dog" + rowNum + "Weight' /></td><td><input class='form-control' type='text' name='dog" + rowNum + "Age' /></td><td><input class='form-control' type='text' name='dog" + rowNum + "Color' /></td><td><select class='form-control' name='dog" + rowNum + "Gender'><option value='Male'>Male</option><option value='Female'>Female</option></select></td><td><select class='form-control' name='dog" + rowNum + "Neutered'><option value='Yes'>Yes</option><option value='No'>No</option></select></td> </tr>");


  "change #has-partner-roommate": (event, template) ->
    template.$('.partner-wrapper').hide()
    template.$('.roommate-wrapper').hide()
    if $(event.target).val() is 'I have a partner'
      template.$('.partner-wrapper').slideDown()
    else if $(event.target).val() is 'I have a roommate'
      template.$('.roommate-wrapper').slideDown()

  "change #current-address-duration": (event, template) ->
    hideIfValues = ['N/A', '12 months', '12+ months']
    if hideIfValues.indexOf($(event.target).val()) > -1
      template.$('.previous-address-wrapper').fadeOut('fast')
    else
      template.$('.previous-address-wrapper').fadeIn()

  "click #no-to-all-criminal-history": (event, template) ->
    template.$('.criminal-history-input-wrapper select').val('No')
    template.$('.criminal-history-explanation-wrapper').hide()

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
    # CLIFF (1/12/16) CAN PROBABLY DELETE THIS SECTION, THIS CAN NOW BE HANDLED FROM THE SWEET ALERT CALLBACK FUNCTION
    event.preventDefault()

    console.log("Events -> Submit Rental Application Access Form -> @_id is (next line):")
    console.log(@_id)
    console.log(@)

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

    #analytics.track "Submitted Rental Application form"
    #analytics.page title: "Submitted Rental Application form", path: '/submit-rental-application-form'

    if @hasPassword
      swal
        title: "Enter a Note"
        text: "Please describe what was changed in your application so we can process it accordingly."
        type: "input"
        inputPlaceholder: "Enter note here"
        confirmButtonColor: "#4588fa"
        confirmButtonText: "Confirm Changes"
        closeOnConfirm: false
        animation: "slide-from-top"
        , (inputValue) ->
          return false  if inputValue is false

          if inputValue is ""
            swal.showInputError "Please enter a note so we can process your application accordingly."
            return false

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
              swal("Saved!", "Please wait while the PDF is being downloaded.", "success")
              location.href = "#{Router.path('rentalApplication', {id: template.data._id})}/download"

    else
      swal
        title: "Enter a Password"
        text: "Please enter a password for your appplication to keep it protected. You will be prompted to enter it again the next time you visit the form."
        type: "input"
        inputType: "password"
        inputPlaceholder: "Write something"
        confirmButtonColor: "#4588fa"
        confirmButtonText: "Create Password"
        closeOnConfirm: false
        showLoaderOnConfirm: true
        animation: "slide-from-top"
        , (inputValue) ->
          return false  if inputValue is false

          if inputValue is ""
            swal.showInputError "Please enter a password to submit the application!"
            return false

          accessToken = Random.secret()
          Session.set('rentalApplicationAccessToken', accessToken)

          fields =
            password: inputValue
            hasPassword: true
            fields: $('#rental-application-form').serializeFormJSON()
            accessToken: accessToken

          $jSignature = template.$('#signature')
          if $jSignature.jSignature('isModified')
            fields.signature = 
              base30: $jSignature.jSignature('getData', 'base30')
              svgbase64: $jSignature.jSignature('getData', 'svgbase64')

          RentalApplications.update template.data._id,
            $set: fields
            , (err, result) ->
              swal("Saved!", "Please wait while the PDF is being downloaded.", "success")
              location.href = "#{Router.path('rentalApplication', {id: template.data._id})}/download"


  "click .revert-rental-application": (event, template) ->
    Meteor.call 'revertRentalApplication', @_id if confirm "Are you sure you want to revert to '#{@updateNote}'?"
