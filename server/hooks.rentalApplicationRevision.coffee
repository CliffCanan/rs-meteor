RentalApplications.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set.updatedAt = new Date()

  true

RentalApplications.after.update (userId, doc, fieldNames, modifier, options) ->
  if modifier.$set and modifier.$set.isNewRevision
    parentId = doc._id
    processedDoc = _.omit(doc, ['_id', 'status', 'password', 'accessToken', 'hasPassword', 'isNewRevision'])

    processedDoc.parentId = parentId
    processedDoc.revisionSavedAt = new Date()
    RentalApplicationRevisions.insert processedDoc

, fetchPrevious: false
