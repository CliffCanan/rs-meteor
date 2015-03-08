Template.cityHeaderSlider.helpers
  sliderData: ->
    selector = {cityId: @cityId}
    min = 500
    max = 5000
    min: min
    max: max
    value:
      min: if @query.from then parseInt(@query.from) else min
      max: if @query.to then parseInt(@query.to) else max

Template.cityHeaderSlider.rendered = ->
  $slider = @$(".price-slider")
  if $slider.length
    $slider.slider().on "slideStop", (event) ->
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
        Router.go("city", {cityId: data.cityId}, {query: query})
      else if (parseInt(query.to) or max) isnt value[1]
        if max is value[1]
          delete query.to
        else
          query.to = value[1]
        Router.go("city", {cityId: data.cityId}, {query: query})
