Template.discovery.onRendered ->
  console.log(Session.get "shouldHideFooter")

  $.getScript 'https://s3-eu-west-1.amazonaws.com/share.typeform.com/embed.js'

Template.discovery.onDestroyed ->
  Session.set "shouldHideFooter", false

Template.discovery.helpers
  fname: ->
    Session.get "disc_fname"

  lname: ->
    Session.get "disc_lname"

  email: ->
    Session.get "disc_email"

  hasemail: ->
    if Session.get("disc_email").length > 3 then return "1" else return "0"

Template.discovery.events
