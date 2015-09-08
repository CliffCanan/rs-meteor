class RentalApplicationRevision
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.RentalApplicationRevision = _.partial(share.transform, RentalApplicationRevision)

@RentalApplicationRevisions = new Mongo.Collection "rentalApplicationRevisions",
  transform: if Meteor.isClient then share.Transformations.RentalApplicationRevision else null