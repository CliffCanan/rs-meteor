Template.cityHeader.helpers
  currentCity: ->
    cities[@cityId].long
  currentBedroomType: ->
    btypes[@query.btype]?.lower ? "Any"

Template.cityHeader.rendered = ->

Template.cityHeader.events
  "click .dropdown button": (event, template) ->
    $(event.currentTarget).parent().toggleClass("open")

  "click .city-select li": (event, template) ->
    data = template.data
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    Router.go("city", {cityId: $li.attr("data-value"), query: data.query})

  "click .bedroom-type-select li": (event, template) ->
    data = template.data
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    query = data.query
    if btype = $li.attr("data-value")
      query.btype = btype
    else
      delete query.btype
    Router.go("city", {cityId: data.cityId}, {query: query})

  "keyup .building-title-search": _.debounce((event, template) ->
    event.preventDefault()
    data = template.data
    q = encodeURIComponent($(event.currentTarget).val())
    query = data.query
    if q
      query.q = q
    else
      delete query.q
    Router.go("city", {cityId: data.cityId}, {query: query})
  , 200)
