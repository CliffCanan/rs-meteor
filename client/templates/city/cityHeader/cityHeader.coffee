Template.cityHeader.helpers
  currentCity: ->
    cities[@cityId].long
  currentBedroomType: ->
    btypes[@query.btype] ? "Any"
  sliderData: ->
    selector = {cityId: @cityId}
    min = Buildings.findOne(selector, {sort: {priceMin: 1}})?.priceMin
    max = Buildings.findOne(selector, {sort: {priceMax: -1}})?.priceMax
    if min and max
      min: min
      max: max
      value:
        min: if @query.priceMin then parseInt(@query.priceMin) else min
        max: if @query.priceMax then parseInt(@query.priceMax) else max

Template.cityHeader.rendered = ->
  $slider = @$(".slider")
  if $slider.length
    $slider.slider().on "slideStop", (event) ->
      $slider = $(event.currentTarget)
      value = event.value
      data = Router.current(reactive: false).data()
      query = data.query
      if parseInt(query.priceMin) isnt value[0]
        if $slider.data("slider-min") is value[0]
          delete query.priceMin
        else
          query.priceMin = value[0]
        Router.go("city", {cityId: data.cityId}, {query: query})
      else if parseInt(query.priceMax) isnt value[1]
        if $slider.data("slider-max") is value[1]
          delete query.priceMax
        else
          query.priceMax = value[1]
        Router.go("city", {cityId: data.cityId}, {query: query})

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
