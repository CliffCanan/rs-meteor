Template.cityHeader.events
  "click .dropdown button": (event, template) ->
    $(event.currentTarget).parent().toggleClass("open")
