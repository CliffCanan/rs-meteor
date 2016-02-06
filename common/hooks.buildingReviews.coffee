BuildingReviews.after.insert (userId, buildingReview) ->
  updateAverageRating(buildingReview)

BuildingReviews.after.update (userId, buildingReview, fieldNames, modifier, options) ->
  updateAverageRating(buildingReview)

updateAverageRating = (buildingReview) ->
  buildingId = buildingReview.buildingId
  allReviews = BuildingReviews.find({buildingId: buildingId, isPublished: true}, {sort: {createdAt: -1}})

  totalRating = _.reduce allReviews.fetch(), (memo, review) ->
    singleReview = 0
    singleReview += +review.totalRating
    singleReview += +reviewItem.score for reviewItem in review.reviewItems

    singleReviewRaw = (singleReview / 40) * 10

    memo + singleReviewRaw
  , 0

  averageRating = (totalRating / allReviews.count()).toFixed(1)
  Buildings.direct.update(buildingId, {$set: {averageRating: averageRating}})