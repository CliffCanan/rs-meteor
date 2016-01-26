Template.layout.helpers
  isHomePage: ->
    Iron.controller().location.get().pathname is "/"

Template.layout.rendered = ->


console.log("Layout.js.cof -> #1")

Template.layout.onCreated = ->
  console.log("Layout.js.cof -> #2 (onCreated)")
$.getScript '/misc/fg-line.js'
