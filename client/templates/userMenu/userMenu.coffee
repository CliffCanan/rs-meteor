Template.userMenu.helpers
  userName: ->
    Meteor.user().profile.name
  pendingReviewsCount: ->
    Counts.get 'pendingReviewsCount'
  rentalApplicationsCount: ->
    Counts.get 'rentalApplicationsCount'

Template.userMenu.rendered = ->

Template.userMenu.events
  "click #delete-recommendation": (event, template) ->
    if confirm "Are you sure you want to delete this recommendation list and all buildings associated with it?"
      clientRecommendation = Template.currentData()
      Meteor.call "deleteClientRecommendationAndBuildings", clientRecommendation._id, (err, result) ->
        Router.go "/"