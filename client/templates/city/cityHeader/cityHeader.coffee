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

    Router.go("city", {cityId: data.cityId}, {query: query})

  "click .form-building-features-filter-reset": (event, template) ->
    $form = $(event.currentTarget).closest("form")
    $form.get(0).reset()
    $form.trigger("submit")
