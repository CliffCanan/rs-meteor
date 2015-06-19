Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    $('.filter-wrap .dropdown-toggle').removeClass('disabled')
    $('.filter-wrap .building-title-search').removeAttr('disabled')
    $('.price-slider').slider('enable')
    Session.set 'showRecommendations', null
  "click #my-recommendations-toggle": ->
    $('.filter-wrap .dropdown-toggle').addClass('disabled')
    $('.filter-wrap .building-title-search').attr('disabled', 'disabled')
    $('.price-slider').slider('disable')
    Session.set 'showRecommendations', true