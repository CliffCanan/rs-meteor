Template.discovery.onRendered ->
  $.getScript 'https://s3-eu-west-1.amazonaws.com/share.typeform.com/embed.js', (x, status) ->
    console.log("Typeform JS retrieved, Status: " + status)

Template.discovery.helpers

Template.discovery.events
