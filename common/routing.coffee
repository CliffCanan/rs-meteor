adminSubs = new SubsManager()
buildingSubs = new SubsManager()

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
  @route "/login",
    name: "login"
  @route "/userlist/:userListId",
    name: "userlist"
    subscriptions: ->
      adminSubs.subscribe("allBuildings", @params.userListId)
    data: ->
      userList = UserLists.findOne({_id: @params.userListId})
      return _.defaults({}, @params,
        userList: userList
      )
    onBeforeAction: ->
      @next()
  @route "/city/:cityId",
    name: "city"
    fastRender: true
    subscriptions: ->
      citySubsciption = Meteor.subscribe("buildings", @params.cityId, @params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
      if Meteor.isClient
        window.citySubsciption = citySubsciption
      [
        citySubsciption
        Meteor.subscribe("city-buildings-count", @params.cityId, @params.query)
      ]
    data: ->
      return null  unless @params.cityId in cityIds
      @params
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
        Session.set("cityScroll", 0)
      share.setPageTitle("Rental Apartments and Condos in " + cities[@params.cityId].long)
      @next()
  @route "/city/:cityId/:neighborhoodSlug/:buildingSlug/:unitSlug?",
    name: "building"
    fastRender: true
    waitOn: ->
      buildingSubs.subscribe("building", @params.cityId, @params.unitSlug or @params.buildingSlug)
    subscriptions: ->
      [
        buildingSubs.subscribe("buildingParent", @params.cityId, @params.unitSlug or @params.buildingSlug)
        buildingSubs.subscribe("buildingUnits", @params.cityId, @params.unitSlug or @params.buildingSlug)
        buildingSubs.subscribe("buildingAdminSame", @params.cityId, @params.unitSlug or @params.buildingSlug)
      ]
    data: ->
      building = Buildings.findOne({cityId: @params.cityId, slug: @params.unitSlug or @params.buildingSlug})
      return null unless building
      _.extend {}, @params,
        building: building
    onBeforeAction: ->
      if @building
        share.setPageTitle(@building.title + ", " + cities[@params.cityId].long)
      @next()
  @route "/autologin/:token",
    name: "autologin"
    onBeforeAction: ->
      Meteor.loginWithToken(@params.token)
      share.autologinDetected = true
      Router.go("index")
  @route "/admin/userspanel",
    name: "usersPanel"
    subscriptions: ->
      Meteor.subscribe("allUsers")
    data: ->
      return null  unless users = Meteor.users.find()
      _.extend @params,
        users: users
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
