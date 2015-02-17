Template.layout.helpers
  isHomePage: ->
    Iron.controller().location.get().path is "/"

Template.layout.rendered = ->
  document.getElementById('socialButtonsScript').src = document.getElementById('socialButtonsScript').src + "" + Meteor.settings.public.addThis.token

Template.layout.events
