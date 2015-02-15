class CheckAvailabilityRequest
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.CheckAvailabilityRequest = _.partial(share.transform, CheckAvailabilityRequest)

@CheckAvailabilityRequests = new Mongo.Collection("CheckAvailabilityRequests",
  transform: if Meteor.isClient then share.Transformations.CheckAvailabilityRequest else null
)

@CheckAvailabilityRequestPreSave = (changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

CheckAvailabilityRequests.before.insert (userId, CheckAvailabilityRequest) ->
  cl CheckAvailabilityRequest
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