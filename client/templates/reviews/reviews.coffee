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
    buildings = Template.instance().data.buildingReviews.fetch()
    totalRating = 0
    for building in buildings
      totalRating += parseInt(building.totalRating, 10)

    (totalRating / buildings.length).toFixed(1)

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
    $review = $target.parents('li')

    $('.reviews li').css(zIndex: 10)

    if $target.html() is 'View More'
      $target.parent().siblings('.review-breakdown').slideDown()
      $target.parent().siblings('.review-body-summary').hide()
      $target.parent().siblings('.review-body-full').show()
      $('.review-view-more').html('View More')
      #$('footer').css('opacity', 0.3)
      $review.css
        zIndex: 20
      $target.html('View Less')
    else
      $('.review-breakdown').hide()
      $('.review-body-summary').show()
      $('.review-body-full').hide()
      #$('footer').css('opacity', 1)
      $target.html('View More')