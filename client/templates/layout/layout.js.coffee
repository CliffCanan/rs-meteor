Template.layout.helpers
  isHomePage: ->
    Iron.controller().location.get().pathname is "/"

Template.layout.rendered = ->

Template.layout.events
