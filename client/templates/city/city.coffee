Template.city.helpers
  buildings: ->
    Buildings.find()

Template.city.rendered = ->
  $('.slider').slider()
