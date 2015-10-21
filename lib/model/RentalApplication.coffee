class RentalApplication
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.RentalApplication = _.partial(share.transform, RentalApplication)

@RentalApplications = new Mongo.Collection "rentalApplications",
  transform: if Meteor.isClient then share.Transformations.RentalApplication else null