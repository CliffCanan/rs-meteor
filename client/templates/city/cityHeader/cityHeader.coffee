Template.cityHeader.onRendered ->
  Meteor.typeahead.inject()
  if Session.get "enteredAddress"
    $('#address').val(Session.get "enteredAddress")

  if not Session.get "travelMode"
    Session.set "travelMode", "walking"

  $('#location-filter-wrapper').find('.dropdown.city-filter').on('shown.bs.dropdown', ->
    $('#address').focus()
  )

  Tracker.autorun ->
    if Router.current() and Router.current().route.getName() is 'city'
      Meteor.setTimeout ->
        $('.neighborhood-select .typeahead').typeahead('val', 'reset')
        $('.neighborhood-select .typeahead').typeahead('val', '')

  $('.neighborhood-select .fa-times').show() if Router.current() and Router.current().route.getName() is 'neighborhood'

Template.cityHeader.helpers
  currentCity: ->
    cityId = @query.cityId || @cityId
    cities[cityId].long
  currentNeighborhood: ->
    if neighborhoodsListRaw?
      neighborhoodSlug = @query.neighborhoodSlug || @neighborhoodSlug
      neighborhoodsListRaw[neighborhoodSlug] || ''
  neighborhoods: ->
    cityId = @query.cityId || @cityId
    share.neighborhoodsInCity cityId
  currentBedroomType: ->
    btypes[@query.btype]?.lower ? "Any"
  arrivalTime: ->
    lessThanTxt = (if $(window).width() < 600 then "<" else "Less than")
    if Session.get("selectedTime")
      selectedTime = Session.get("selectedTime")
      if selectedTime is "10m"
        lessThanTxt + " 10 min"
      else if selectedTime is "20m"
        lessThanTxt + " 20 min"
      else lessThanTxt + " 30 min"  if selectedTime is "30m"
    else
      lessThanTxt + " 10 min"
  travelMode: ->
    Session.get('travelMode')
  getDestination: ->
    destination = if Session.get('cityName') then Session.get('cityName') else ''
  neighborhoodSearch: (query, sync, async) ->
    neighborhoods = share.neighborhoodsInCity(Router.current().data().cityId)
    neighborhoodsObject = []
    if neighborhoods
      if not query or query is 'All'
        # Get Top 8 neighborhood by number of properties in each neighborhood. The neighborhood array is conveniently sorted by
        # most properties first.
        for neighborhood in (_.first(neighborhoods, 8))
          neighborhoodsObject.push
            id: neighborhood.slug
            value: neighborhood.name
      else
        regex = new RegExp query, 'i'
        filtered = _.filter neighborhoods, (obj) ->
          obj.name.match regex

        if filtered.length
          for neighborhood in filtered
            neighborhoodsObject.push
              id: neighborhood.slug
              value: neighborhood.name

      if Router.current().route.getName() is 'neighborhood'
        neighborhoodsObject.push
          id: 'all'
          value: 'Show all'

    sync neighborhoodsObject

  selectedNeighborhood: (event, suggestion, datasetName) ->
    event.preventDefault()
    neighborhoodSlug = suggestion.id
    data = Template.instance().data

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
    Session.set "enteredAddress", null
    delete data.query['address'] if data.query.address
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    routeName = Router.current().route.getName()
    if routeName is "clientRecommendations"
      data.query.cityId = $li.attr("data-value")
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: data.query})
    else
      Router.go("city", {cityId: $li.attr("data-value")}, {query: data.query})

  "focus .typeahead": (event, template) ->
    $target = $(event.target)

    $(event.target).typeahead('val', '')
    $target.attr('placeholder', 'Type any neighborhood')

  "blur .typeahead": (event, template) ->
    data = template.data
    if data.neighborhoodSlug
      $(event.target).typeahead('val', neighborhoodsListRaw[data.neighborhoodSlug])
    else
      $(event.target).attr('placeholder', 'Search neighborhood')

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
    if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
    else
      routeParams = {}
      routeParams.cityId = data.cityId if data.cityId
      routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
      Router.go(routeName, routeParams, {query: query})

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
    if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
    else
      routeParams = {}
      routeParams.cityId = data.cityId if data.cityId
      routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
      Router.go(routeName, routeParams, {query: query})
  , 300)

  "click #filterAddress": (event, template) ->
    event.preventDefault()
    data = template.data
    query = data.query
    query.address = $("#address").val()

    routeName = Router.current().route.getName()
    routeParams = {}
    routeParams.cityId = data.cityId if data.cityId
    routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
    Router.go(routeName, routeParams, {query: query}, 300)

  "click #show-unpublished-properties-toggle": (event, template) ->
    currentValue = Session.get('adminShowUnpublishedProperties')
    Session.set('adminShowUnpublishedProperties', !currentValue)

  "submit .form-building-filter": (event, template) ->
    event.preventDefault()

    data = template.data
    query = data.query

    if $("#address").val() != ""
      query.address = $("#address").val()
      Session.set('enteredAddress', query.address)
    else
      Session.set('enteredAddress', null)
      delete query["address"]

    $form = $(event.currentTarget)
    $form.closest(".dropdown").removeClass("open")    
    
    routeName = Router.current().route.getName()
    routeParams = {}
    routeParams.cityId = data.cityId if data.cityId
    routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
    Router.go(routeName, routeParams, {query: query}, 300)

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
    if routeName is "clientRecommendations"
      Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
    else
      routeParams = {}
      routeParams.cityId = data.cityId if data.cityId
      routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
      Router.go(routeName, routeParams, {query: query})

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
