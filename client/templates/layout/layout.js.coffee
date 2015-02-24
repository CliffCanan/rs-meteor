Template.layout.helpers
  isHomePage: ->
    Iron.controller().location.get().path is "/"

Template.layout.rendered = ->

Template.layout.events
