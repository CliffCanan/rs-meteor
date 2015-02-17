subs = new SubsManager()

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.plugin("dataNotFound", {notFoundTemplate: "notFound"})

Router.map ->
  @route "/",
    name: "index"
    onBeforeAction: ->
      share.setPageTitle("Rent Scene - Apartments and Condos for Rent", false)
      @next()
  @route "/check-availability",
    name: "checkAvailability"
  @route "/:cityId",
    name: "city"
    fastRender: true
    subscriptions: ->
      subs.subscribe("buildings", @params.cityId)
    data: ->
      return null  unless @params.cityId in cityIds
      @params
    onBeforeAction: ->
      share.setPageTitle("Rental Apartments and Condos in " + cities[@params.cityId])
      @next()
  @route "/:cityId/:neighborhood/:buildingSlug",
    name: "building"
    fastRender: true
    subscriptions: ->
      Meteor.subscribe("buildings", @params.cityId, @params.buildingSlug)
    data: ->
      return null  unless building = Buildings.findOne({cityId: @params.cityId, slug: @params.buildingSlug})
      _.extend @params
        building: building
    onBeforeAction: ->
      if @building
        share.setPageTitle(@building.name + ", " + cities[@params.cityId])
      @next()
  @route "/autologin/:token",
    name: "autologin"
    onBeforeAction: ->
      Meteor.loginWithToken(@params.token)
      share.autologinDetected = true
      Router.go("index")
  @route "/(.*)",
    name: "notFound"

if Meteor.isClient
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
