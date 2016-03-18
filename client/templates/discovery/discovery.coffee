Template.discovery.onRendered ->
  console.log(Session.get "shouldHideFooter")

  $.getScript 'https://s3-eu-west-1.amazonaws.com/share.typeform.com/embed.js'

Template.discovery.onDestroyed ->
  Session.set "shouldHideFooter", false

Template.discovery.helpers

Template.discovery.events
