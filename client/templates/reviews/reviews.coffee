Template.reviews.onRendered ->
  instance = @
  Tracker.autorun ->
    if instance.data and instance.data.building
      if BuildingReviews.find({buildingId: instance.data.building._id, isPublished: true, isRemoved: null})
        $reviewsItem = $('.reviews li')
        total = $reviewsItem.size()

        rows = Math.round(total / 2)

        if Security.canOperateWithBuilding()
          $('.reviews').css(height: rows * 260)
        else
          $('.reviews').css(height: rows * 190)

        $reviewsItem.each ->
          $this = $(this)
          $this.css('position', 'relative')
          position = $this.position()
          $this.data('position-top', position.top)
          $this.data('position-left', position.left)

        $reviewsItem.each ->
          $this = $(this)
          $this.css
            position: 'absolute'
            top: $this.data('position-top')
            left: $this.data('position-left')
            zIndex: 10

Template.reviews.helpers
  averageRating: ->
    allReviews = Template.instance().data.buildingReviews.fetch()
    totalRating = 0

    for review in allReviews
      singleReview = 0
      singleReview += parseInt(review.totalRating, 10)

      # Now loop through each sub-score and add them to get a raw score out of (out of a max of 40 total points)
      singleReview += parseInt(review.score, 10) for review in review.reviewItems
      console.log(singleReview)

      singleReviewRaw = ((singlescore / 40) * 10).toFixed(2)
      console.log(singleReviewRaw)
      console.log(typeof singleReviewRaw)

      totalRating += singleReviewRaw
      console.log(totalRating)

    (totalRating / allReviews.length).toFixed(1)

  reviewsCount: ->
    Template.instance().data.buildingReviews.count()

  reviewText: ->
    ratingsCount = Template.instance().data.buildingReviews.count() 
    if ratingsCount is 1
      'review'
    else
      'reviews'

Template.reviews.events
  'click #review-form-link': (event, template) ->
    Session.set('reviewFormDefaults', null)

  'click .review-view-more': (event, template) ->
    $target = $(event.target)
    $review = $target.parents('.review')

    if $target.html() is 'View More...'
      $review.css
        height: 'auto'
      $target.parent().siblings('.review-body-summary').hide()
      $target.parent().siblings('.review-body-full').slideDown(300)
      $target.parent().siblings('.review-breakdown').slideDown(300)
      $target.html('View Less')
    else
      $review.css
        height: '195px'
      $target.parent().siblings('.review-breakdown').slideUp(300)
      $target.parent().siblings('.review-body-full').slideUp(300)
      $target.parent().siblings('.review-body-summary').show()
      $target.html('View More...')