updateSliderDisplayValues = (from, to) ->
  from = from || 500
  to = to || 5000
  $(".slider-price-from").text(accounting.formatNumber(from))
  $(".slider-price-to").text(accounting.formatNumber(to))

Template.cityHeaderSlider.helpers
  sliderData: ->
    selector = {cityId: @cityId}
    min = 500
    max = 5000
    minValue = if @query.from then parseInt(@query.from) else min
    maxValue = if @query.to then parseInt(@query.to) else max
    min: min
    max: max
    value:
      min: minValue
      max: maxValue

Template.cityHeaderSlider.rendered = ->
  $slider = @$(".price-slider")
  if $slider.length

    data = Router.current().data()
    query = data.query

    minValue = if query.from then parseInt(query.from) else 500
    maxValue = if query.to then parseInt(query.to) else 5000
    updateSliderDisplayValues(minValue, maxValue)

    $slider.slider({tooltip: "hide"})
    .on "slideStop", (event) ->
      min = $slider.data("slider-min")
      max = $slider.data("slider-max")
      value = event.value
      routeName = Router.current().route.getName()
      if (parseInt(query.from) or min) isnt value[0]
        if min is value[0]
          delete query.from
        else
          query.from = value[0]
        if routeName is "city"
          Router.go("city", {cityId: data.cityId}, {query: query})
        else if routeName is "clientRecommendations"
          Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
      else if (parseInt(query.to) or max) isnt value[1]
        if max is value[1]
          delete query.to
        else
          query.to = value[1]
        if routeName is "city"
          Router.go("city", {cityId: data.cityId}, {query: query})
        else if routeName is "clientRecommendations"
          Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
    .on "slide", (event) ->
      updateSliderDisplayValues(event.value[0], event.value[1])
