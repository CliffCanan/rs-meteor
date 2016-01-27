Template.layout.helpers
  isHomePage: ->
    Iron.controller().location.get().pathname is "/"

Template.layout.rendered = ->

console.log("Layout.js.cof -> #1")
#$.getScript '/misc/fg-line.js'

Template.layout.onCreated = ->
  console.log("Layout.js.cof -> #2 (onCreated)")
