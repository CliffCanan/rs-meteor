class BuildingReview
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.BuildingReview = _.partial(share.transform, BuildingReview)

@BuildingReviews = new Mongo.Collection "buildingReviews"