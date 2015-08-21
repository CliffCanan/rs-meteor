Template.reviews.onRendered ->
  $reviewsItem = $('.reviews li')
  total = $reviewsItem.size()

  rows = Math.round(total / 2)

  if Security.canOperateWithBuilding()
    $('.reviews').css(height: rows * 280)
  else
    $('.reviews').css(height: rows * 230)

  $reviewsItem.each ->
    $this = $(this)
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

Template.reviews.events
  'click .review-view-more': (event, template) ->
    $target = $(event.target)
    $review = $target.parents('li')
    $('.review-breakdown').hide()
    $('.reviews li').css(zIndex: 10)

    if $target.html() is 'View more'
      $target.parent().siblings('.review-breakdown').show()      
      $('.review-view-more').html('View more')
      $('footer').css('opacity', 0.3)
      $review.css
        zIndex: 20
      $target.html('View less')
    else
      $('footer').css('opacity', 1)
      $target.html('View more')