Template.cityHeader.onRendered ->
  Meteor.typeahead.inject()
  if Session.get "enteredAddress"
    $('#address').val(Session.get "enteredAddress")

  if not Session.get "travelMode"
    Session.set "travelMode", "walking"

  $('#location-filter-wrapper').find('.dropdown.city-filter').on('shown.bs.dropdown', ->
    $('#address').focus()
  )

Template.cityHeader.helpers
  currentCity: ->
    cityId = @query.cityId || @cityId
    cities[cityId].long
  currentNeighborhood: ->
    neighborhoodSlug = @query.neighborhoodSlug || @neighborhoodSlug
    neighborhoodsListRaw[neighborhoodSlug] || 'All'
  neighborhoods: ->
    cityId = @query.cityId || @cityId
    share.neighborhoodsInCity cityId
  currentBedroomType: ->
    btypes[@query.btype]?.lower ? "Any"
  arrivalTime: ->
    if Session.get "selectedTime"
      selectedTime = Session.get "selectedTime"
      if selectedTime == "10m"
        "Less than 10min"
      else if selectedTime == "20m"
        "Less than 20min"
      else if selectedTime == "30m"
        "Less than 30min"
    else
      "Less than 10min"
  travelMode: ->
    Session.get('travelMode')
  getDestination: ->
    destination = if Session.get('cityName') then Session.get('cityName') else ''
  neighborhoodSearch: (query, sync, async) ->
    neighborhoods = share.neighborhoodsInCity(Template.instance().data.cityId)
    neighborhoodsObject = []
    if query
      regex = new RegExp query, 'i'
      filtered = _.filter neighborhoods, (obj) ->
        obj.name.match regex

      if filtered.length
        for neighborhood in filtered
          neighborhoodsObject.push
            id: neighborhood.slug
            value: neighborhood.name
    else
      # Get Top 8 neighborhood by number of properties in each neighborhood. The neighborhood array is conveniently sorted by
      # most properties first.
      for neighborhood in (_.first(neighborhoods, 8))
        neighborhoodsObject.push
          id: neighborhood.slug
          value: "Popular: #{neighborhood.name}"

    neighborhoodsObject.push
      id: 'all'
      value: 'Show all'

    sync neighborhoodsObject
  selectedNeighborhood: (event, suggestion, datasetName) ->
    neighborhoodSlug = suggestion.id
    data = Template.instance().data
    delete data.query['address'] if data.query.address
    delete data['neighborhoodSlug'] if data.neighborhoodSlug
    delete data.query['neighborhoodSlug'] if data.query.neighborhoodSlug

    if neighborhoodSlug is 'all'
      Router.go("city", {cityId: Router.current().data().cityId}, {query: data.query})
    else
      routeName = Router.current().route.getName()
      if routeName is "clientRecommendations"
        data.query.cityId = $li.attr("data-value")
        Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: data.query})
      else
        Router.go("neighborhood", {cityId: Router.current().data().cityId, neighborhoodSlug: neighborhoodSlug}, {query: data.query})

Template.cityHeader.events
  "click .selectArrivalTime .dropdown button": (event, template) ->
    $(event.currentTarget).parent().toggleClass("open")

  "click .city-select li": (event, template) ->
    data = template.data
    delete data.query['address'] if data.query.address
    delete data['neighborhoodSlug'] if data.neighborhoodSlug
    delete data.query['neighborhoodSlug'] if data.query.neighborhoodSlug
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    routeName = Router.current().route.getName()
    if routeName is "clientRecommendations"
      data.query.cityId = $li.attr("data-value")
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: data.query})
    else
      Router.go("city", {cityId: $li.attr("data-value")}, {query: data.query})

  "click .typeahead": (event, template) ->
    $(event.target).typeahead('val', '');

  "click .bedroom-type-select li": (event, template) ->
    data = template.data
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    query = data.query
    if btype = $li.attr("data-value")
      query.btype = btype
    else
      delete query.btype
    routeName = Router.current().route.getName()
    if routeName is "city"
      Router.go("city", {cityId: data.cityId}, {query: query})
    else if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})

  "click .travelMode": (event, template) ->
    $item = $(event.currentTarget)
    if $item.attr("id") == "walker"
      Session.set("travelMode", "walking")
    if $item.attr("id") == "car"
      Session.set("travelMode", "driving")
    if $item.attr("id") == "bike"
      Session.set("travelMode", "bicycling")

  "click .selectTime": (event, template) ->
    $item = $(event.currentTarget)
    $item.closest(".dropdown").removeClass("open")
    Session.set("selectedTime", $item.attr("id"))

  "keyup .building-title-search": _.debounce((event, template) ->
    event.preventDefault()
    data = template.data
    q = encodeURIComponent($(event.currentTarget).val())
    query = data.query
    if q
      query.q = q
    else
      delete query.q
    routeName = Router.current().route.getName()
    if routeName is "city"
      Router.go("city", {cityId: data.cityId}, {query: query})
    else if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
  , 300)

  "click #filterAddress": (event, template) ->
    event.preventDefault()
    data = template.data
    query = data.query
    #console.log typeof data
    query.address = $("#address").val() 
    Router.go("city", {cityId: data.cityId}, {query: query}, 300)

  "submit .form-building-filter": (event, template) ->
    event.preventDefault()

    event.preventDefault()
    data = template.data
    query = data.query
    #console.log typeof data
    if $("#address").val() != ""
      query.address = $("#address").val()
      Session.set('enteredAddress', query.address)
    else
      Session.set('enteredAddress', null)
      delete query["address"]

    $form = $(event.currentTarget)
    $form.closest(".dropdown").removeClass("open")    
    Router.go("city", {cityId: data.cityId}, {query: query}, 300)

  "submit .form-building-features-filter": (event, template) ->
    event.preventDefault()

    fieldNames = ["security", "fitnessCenter", "pets", "laundry", "parking", "utilities"]
    data = template.data
    query = data.query
    $form = $(event.currentTarget)
    $form.closest(".dropdown").removeClass("open")
    values = $form.serializeJSON({parseAll: true})
    for fieldName in fieldNames
      if value = values[fieldName]
        query[fieldName] = value
      else
        delete query[fieldName]
    if values.available
      query.available = encodeURIComponent(values.available)
    else
      delete query.available

    routeName = Router.current().route.getName()
    if routeName is "city"
      Router.go("city", {cityId: data.cityId}, {query: query})
    else if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})

  "click .form-building-address-filter-reset": (event, template) ->
    Session.set("travelMode", "walking")
    Session.set("selectedTime", "")
    $form = $(event.currentTarget).closest("form")
    $form.get(0).reset()
    $form.trigger("submit")

  "click .form-building-features-filter-reset": (event, template) ->
    $form = $(event.currentTarget).closest("form")
    $form.get(0).reset()
    $form.trigger("submit")

  "click .show-all-listings": ->
    Session.set "showRecommendations", false
    return
