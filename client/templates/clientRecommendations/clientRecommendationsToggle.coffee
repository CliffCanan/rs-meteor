Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    Session.set 'clientRecommendationsBuildingIds', null
  "click #my-recommendations-toggle": ->
    buildingIds = Router.current().data().buildingIds
    Session.set 'clientRecommendationsBuildingIds', buildingIds