class ContactUsRequest
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.ContactUsRequest = _.partial(share.transform, ContactUsRequest)

@ContactUsRequests = new Mongo.Collection("ContactUsRequests",
  transform: if Meteor.isClient then share.Transformations.ContactUsRequest else null
)

@ContactUsRequestPreSave = (changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

ContactUsRequests.before.insert (userId, ContactUsRequest) ->
  ContactUsRequest._id ||= Random.id()
  now = new Date()
  _.defaults(ContactUsRequest,
    updatedAt: now
    createdAt: now
  )
  ContactUsRequestPreSave.call(@, ContactUsRequest)
  true

ContactUsRequests.before.update (userId, ContactUsRequest, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  ContactUsRequestPreSave.call(@, modifier.$set)
  true

ContactUsRequests.after.insert (userId, request) ->
  if Meteor.isServer
    transformedRequest = share.Transformations.ContactUsRequest(request)
    Email.send
      from: transformedRequest.email
      to: 'rentscenetest+' + transformedRequest.city + '@gmail.com'
      replyTo: transformedRequest.email
      subject: 'New check availability request from ' + transformedRequest.name + ' in ' + transformedRequest.city
      html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))

