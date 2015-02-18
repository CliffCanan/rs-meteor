Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.map ->
  @route "/",
    name: "index"
    onBeforeAction: ->
      share.setPageTitle("Rent Scene - Apartments and Condos for Rent", false)
      @next()
  @route "/checkAvailability",
    name: "checkAvailability"
  @route "/login",
    name: "login"
  @route "/:city",
    name: "city"
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
