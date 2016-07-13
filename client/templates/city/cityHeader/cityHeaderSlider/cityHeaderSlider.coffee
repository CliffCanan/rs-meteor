updateSliderDisplayValues = (from, to) ->
  from = from || 500
  to = to || 4000
  $(".slider-price-from").text(accounting.formatNumber(from))
  $(".slider-price-to").text(accounting.formatNumber(to))

Template.cityHeaderSlider.helpers
  sliderData: ->
    selector = {cityId: @cityId}
    min = 500
    max = 4000
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
    maxValue = if query.to then parseInt(query.to) else 4000
    updateSliderDisplayValues(minValue, maxValue)

    $slider.slider({tooltip: "hide"})
    .on "slideStop", (event) ->
      min = $slider.data("slider-min")
      max = $slider.data("slider-max")
      value = event.value

      data = Router.current().data()
      query = data.query

      if (parseInt(query.from) or min) isnt value[0]
        if min is value[0]
          delete query.from
        else
          query.from = value[0]
      else if (parseInt(query.to) or max) isnt value[1]
        if max is value[1]
          delete query.to
        else
          query.to = value[1]


      analytics.track "Searched by PRICE", {label: value[0], max: value[1]} unless Meteor.user()

      routeName = Router.current().route.getName()

      if routeName is "clientRecommendations"
        Router.go("clientRecommendations", {clientId: Router.current().data().clientId}, {query: query})
      else
        routeParams = {}
        routeParams.cityId = data.cityId if data.cityId
        routeParams.neighborhoodSlug = data.neighborhoodSlug if data.neighborhoodSlug
        Router.go(routeName, routeParams, {query: query})

    .on "slide", (event) ->
      updateSliderDisplayValues(event.value[0], event.value[1])
