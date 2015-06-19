Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    Session.set 'showRecommendations', null
  "click #my-recommendations-toggle": ->
    Session.set 'showRecommendations', true