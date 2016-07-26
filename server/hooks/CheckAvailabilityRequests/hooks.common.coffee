sanitizeHtml = Meteor.npmRequire('sanitize-html')

CheckAvailabilityRequestPreSave = (changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now
  changes.name = sanitizeHtml changes.name, {allowedTags: []}

CheckAvailabilityRequests.before.insert (userId, CheckAvailabilityRequest) ->
  CheckAvailabilityRequest._id ||= Random.id()
  now = new Date()
  _.defaults(CheckAvailabilityRequest,
    updatedAt: now
    createdAt: now
  )
  CheckAvailabilityRequestPreSave.call(@, CheckAvailabilityRequest)
  true

CheckAvailabilityRequests.before.update (userId, CheckAvailabilityRequest, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  CheckAvailabilityRequestPreSave.call(@, modifier.$set)
  true
