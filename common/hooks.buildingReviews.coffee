BuildingReviews.after.insert (userId, buildingReview) ->
  updateAverageRating(buildingReview)

BuildingReviews.after.update (userId, buildingReview, fieldNames, modifier, options) ->
  updateAverageRating(buildingReview)

updateAverageRating = (buildingReview) ->
  buildingId = buildingReview.buildingId
  allReviews = BuildingReviews.find({buildingId: buildingId, isPublished: true}, {sort: {createdAt: -1}})

  totalRating = _.reduce allReviews.fetch(), (memo, num) ->
    memo + +num.totalRating
  , 0

  averageRating = (totalRating / allReviews.count()).toFixed(2)

  Buildings.direct.update(buildingId, {$set: {averageRating: averageRating}})