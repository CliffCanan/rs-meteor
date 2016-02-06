BuildingReviews.after.insert (userId, buildingReview) ->
  updateAverageRating(buildingReview)

BuildingReviews.after.update (userId, buildingReview, fieldNames, modifier, options) ->
  updateAverageRating(buildingReview)

updateAverageRating = (buildingReview) ->
  buildingId = buildingReview.buildingId
  allReviews = BuildingReviews.find({buildingId: buildingId, isPublished: true}, {sort: {createdAt: -1}}).fetch()

  #totalRating = _.reduce allReviews.fetch(), (memo, num) ->
  #  memo + +num.totalRating
  #, 0

  totalRating = 0

  for review in allReviews
    singleReview = 0
    singleReview += parseInt(review.totalRating, 10)

    # Now loop through each sub-score and add them to get a raw score (out of a max of 40 total points)
    singleReview += parseInt(review.score, 10) for review in review.reviewItems

    singleReviewRaw = (singleReview / 40) * 10

    totalRating += singleReviewRaw

  averageRating = (totalRating / allReviews.count()).toFixed(1)

  Buildings.direct.update(buildingId, {$set: {averageRating: averageRating}})