cities =
  atlanta: "ATLANTA, GA"
  boston: "BOSTON, MA"
  chicago: "CHICAGO, IL"
  "los-angeles": "LOS ANGELES, CA"
  philadelphia: "PHILADELPHIA, PA"
  stamford: "STAMFORD, CT"
  washington: "WASHINGTON, DC"

Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.map ->
  @route "index",
    path: "/"
    onBeforeAction: ->
      share.setPageTitle("Rent Scene - Apartments and Condos for Rent", false)
      @next()
  @route "checkAvailability"
  @route "city",
    path: "/:city"
    onBeforeAction: ->
      share.setPageTitle("Rental Apartments and Condos in " + cities[@params.city])
      @next()
  @route "/autologin/:token",
    name: "autologin"
    onBeforeAction: ->
      Meteor.loginWithToken(@params.token)
      share.autologinDetected = true
      Router.go("index")

Router.onAfterAction share.sendPageview

Router.onRun -> # try fixing the lagging scroll issue when logging in from mobile devices while having already scrolled down the page
  $(window).scrollTop(0)
  @next()

share.setPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " | Rent Scene"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  document.title = title
