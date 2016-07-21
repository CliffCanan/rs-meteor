class ContactUsRequest
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.ContactUsRequest = _.partial(share.transform, ContactUsRequest)

@ContactUsRequests = new Mongo.Collection("ContactUsRequests",
  transform: if Meteor.isClient then share.Transformations.ContactUsRequest else null
)
