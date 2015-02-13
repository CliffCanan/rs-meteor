Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "footer": {to: "footer"}

Router.map ->
  @route "index",
    path: "/"
  @route "/autologin/:token",
    name: "autologin"
    onBeforeAction: ->
      Meteor.loginWithToken(@params.token)
      share.autologinDetected = true
      Router.go("index")
  @route "checkAvailability",
    name: "checkAvailability"
    path: "/checkAvailability"
  @route "checkAvailabilityPopup",
    name: "checkAvailabilityPopup"
    path: "/checkAvailabilityPopup"


Router.onAfterAction share.sendPageview

Router.onRun -> # try fixing the lagging scroll issue when logging in from mobile devices while having already scrolled down the page
  $(window).scrollTop(0)
  @next()

share.setPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " - Rentscene"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  document.title = title
