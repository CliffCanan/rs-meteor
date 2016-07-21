Template.clientSearchBar.onCreated ->
  @autorun =>
    clientId = Session.get 'clientId'
    @subscribe "singleClientRecommendation", clientId

Template.clientSearchBar.helpers
  showExitRecommendationIcon: ->
    Template.instance().data.type isnt 'session'

  clientsSearch: (query, sync, async) ->
    Meteor.call "searchClient", query, (error, result) ->
      if error
        console.error "Error occurred in clientsSearch", error
      else
        if result.length
          async result
        else
          async
            id: 'new'
            value: 'Create New Client'

  selectedClient: (event, suggestion, datasetName) ->
    instance = Template.instance()
    $target = $(event.target)

    if suggestion.id is 'new'
      newClientName = instance.$('.twitter-typeahead pre').html()
      $target.val 'Creating new client...'
      
      Meteor.call "createClient", newClientName, (err, data) ->
        cityPageData = Session.get "cityPageData"
        Session.set "showRecommendations", false

        if instance.data.type is 'session'
          $target.val newClientName
          Session.set('clientId', data.clientId)
        else
          $target.val ''
          Router.go "clientRecommendations", {clientId: data.clientId}, query: {cityId: cityPageData.cityId} unless err
    else
      $target.val ''
      if Template.instance().data.type is 'session'
        Session.set('clientId', suggestion.id)
      else
        Router.go "clientRecommendations", {clientId: suggestion.id}

Template.clientSearchBar.onRendered(->
  Meteor.typeahead.inject()
  return
)

Template.clientSearchBar.events
  "click #exit-recommendation-from-bar": (event, template) ->
    event.preventDefault()
    share.exitRecommendationsMode()
    return
