Template.rentalApplication.onRendered ->
  @$('#signature').jSignature()

  instance = @
  Dropzone.autoDiscover = false
  dropzone = new Dropzone '.dropzone',
    accept: (file, done) ->
      insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
        RentalApplications.update(instance.data._id, {$addToSet: {documents: insertedDocument}})

    previewTemplate : '<div style="display:none"></div>'

Template.rentalApplication.helpers
  documents: ->
    data = Template.instance().data
    rentalApplication = RentalApplications.findOne(data._id)

    result = []
    if rentalApplication.documents
      for document in rentalApplication.documents
        result.push(document.getFileRecord())

    result

Template.rentalApplication.events
  "submit form": (event, template) ->
    event.preventDefault()
    signatureData = template.$('#signature').jSignature("getData", "svgbase64")
    signatureURI = "data:#{signatureData.join(",")}"

    file = new FS.File()
    file.attachData signatureURI
    file.name 'Signature.svg'

    insertedDocument = RentalApplicationDocuments.insert file, (err, result) ->
        RentalApplications.update(template.data._id, {$addToSet: {documents: insertedDocument}})