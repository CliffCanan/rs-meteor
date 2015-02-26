Template.cityHeaderSlider.helpers
  sliderData: ->
    selector = {cityId: @cityId}
    min = Buildings.findOne(selector, {sort: {priceMin: 1}})?.priceMin
    max = Buildings.findOne(selector, {sort: {priceMax: -1}})?.priceMax

    _.defer ->
      $slider = @$(".price-slider")
      if $slider.length
        $slider.slider().on "slideStop", (event) ->
          min = $slider.data("slider-min")
          max = $slider.data("slider-max")
          value = event.value
          data = Router.current().data()
          query = data.query
          if (parseInt(query.priceMin) or min) isnt value[0]
            if min is value[0]
              delete query.priceMin
            else
              query.priceMin = value[0]
            Router.go("city", {cityId: data.cityId}, {query: query})
          else if (parseInt(query.priceMax) or max) isnt value[1]
            if max is value[1]
              delete query.priceMax
            else
              query.priceMax = value[1]
            Router.go("city", {cityId: data.cityId}, {query: query})

    if min and max
      min: min
      max: max
      value:
        min: if @query.priceMin then parseInt(@query.priceMin) else min
        max: if @query.priceMax then parseInt(@query.priceMax) else max
