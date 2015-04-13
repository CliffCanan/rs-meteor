class UserReview
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.UserReview = _.partial(share.transform, UserReview)

@UserReviews = new Mongo.Collection "UserReviews",
  transform: if Meteor.isClient then share.Transformations.UserReview else null

UserReviewPreSave = (userId, changes) ->
  now = new Date()
  changes.updatedAt = now

UserReviews.before.insert (userId, UserReview) ->
  UserReview._id ||= Random.id()
  now = new Date()
  _.extend UserReview,
    createdAt: now
  UserReviewPreSave.call(@, userId, UserReview)
  true

UserReviews.before.update (userId, UserReview, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  UserReviewPreSave.call(@, userId, modifier.$set)
  true
