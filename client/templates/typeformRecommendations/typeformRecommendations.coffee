Template.typeformRecommendations.helpers
  recommendations: ->
    ClientRecommendations.find()

  neighborhoods: ->
    @data.neighborhoods.join(", ")

  bedroomTypes: ->
    @data.bedroomTypes.join(", ")

  roommateEmail: ->
    @data.roommateEmail or "Not Set"

  moveinDate: ->
    moment(@data.moveinDate).format("MM/DD/YYYY")

  reasons: ->
    @data.reasons

  flexible: ->
    @data.flexible

  requirements: ->
    @data.requirements.join(", ")

  rent: ->
    @data.rent

  progress: ->
    @data.progress

  details: ->
    @data.details

  email: ->
    @data.email

  name: ->
    @data.name

  hasRoommate: ->
    switch @data.hasRoommate
      when true then "Yes"
      when false then "No"
      else "Not Set"

  linkToRecommendationPage: ->
    Router.path "clientRecommendations", {clientId: @_id}
