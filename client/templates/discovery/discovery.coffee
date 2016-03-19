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
    # Check to make sure the email Session value isn't the default (set in routing.coffee)
    if Session.get("disc_email") is "form-default@nooch.com" then return "0" else return "1"

Template.discovery.events
