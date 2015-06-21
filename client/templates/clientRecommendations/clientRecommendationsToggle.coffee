Template.clientRecommendationsToggle.onRendered ->
  Tracker.autorun ->
    if Session.get 'showRecommendations'
      $('#my-recommendations-toggle').addClass('active')
      $('#all-listings-toggle').removeClass('active')
      $('.filter-wrap .dropdown-toggle').addClass('disabled')
      $('.filter-wrap .building-title-search').attr('disabled', 'disabled')
      $('.price-slider').slider('disable')
      return
    else
      $('#all-listings-toggle').addClass('active')
      $('#my-recommendations-toggle').removeClass('active')
      $('.filter-wrap .dropdown-toggle').removeClass('disabled')
      $('.filter-wrap .building-title-search').removeAttr('disabled')
      $('.price-slider').slider('enable')
      return

Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    Session.set "showRecommendations", null
    return
  "click #my-recommendations-toggle": ->
    Session.set "showRecommendations", true
    return