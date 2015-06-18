Template.clientSearchBar.helpers
  clientsSearch: (query, sync, async) ->
    suggestions = ClientRecommendations.find(name: {$regex: new RegExp query, "i"})
    if suggestions.count()
      sync(suggestions.fetch().map((it)->
        id: it._id
        value: it.name
      ))
      return
    else
      sync([
        id: 'new'
        value: 'Create new'
      ])
      return
  selectedClient: (event, suggestion, datasetName) ->
    $target = $(event.target)
    if suggestion.id is 'new'
      newClientName = $('.twitter-typeahead pre').html();
      Meteor.call "createClient", newClientName, (err, data) ->
        $target.val ''
        Router.go data.url unless err
    else
      $target.val ''
      Router.go "clientRecommendations", {clientId: suggestion.id}

Template.clientSearchBar.onRendered(->
  Meteor.typeahead.inject()
  return
)