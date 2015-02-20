Template.cityHeader.helpers
  currentCity: ->
    cities[@cityId].long
  currentBedroomType: ->
    btypes[if btypes[@query.btype] then @query.btype else ""]

Template.cityHeader.events
  "click .dropdown button": (event, template) ->
    $(event.currentTarget).parent().toggleClass("open")

  "click .city-select li": (event, template) ->
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    Router.go("city", {cityId: $li.attr("data-value")}) # TODO: add query param
