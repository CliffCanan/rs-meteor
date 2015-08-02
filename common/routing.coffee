adminSubs = new SubsManager()
@citySubs = new SubsManager()
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
    onAfterAction: ->
      SEO.set
        meta:
          description: "Rent Scene helps you find a great place to live. Search for apartments and condos in Philadelphia, Washington DC, Chicago, and other major cities."
          keywords: "rent, rental, apartment, home, bedroom, bathroom, lease condo, condominium, philadelphia, chicago, boston, washington dc, rittenhouse square, parking, gym, fitness, utilities, pets"
  @route "/check-availability",
    name: "checkAvailability"
  @route "/tour-signup",
    name: "tourSignup"
  @route "/login",
    name: "login"
  @route "/userlist/:userListId",
    name: "userlist"
    fastRender: true
    subscriptions: ->
      adminSubs.subscribe("allBuildings", @params.userListId)
    data: ->
      userList = UserLists.findOne({_id: @params.userListId})
      return _.defaults({}, @params,
        userList: userList
      )
    onBeforeAction: ->
      @next()
  @route "/propertylist/:slug",
    name: "propertylist"
    fastRender: true
    subscriptions: ->
      [
        Meteor.subscribe("propertyLists")
        Meteor.subscribe("propertyListBuildings", @params.slug)
      ]
    data: ->
      propertyList = PropertyLists.findOne({"slug": String(@params.slug)})
      return _.defaults({}, @params,
        propertyList: propertyList
      )
    onBeforeAction: ->
      @next()
  @route "recommendations/:clientId",
    name: "clientRecommendations"
    fastRender: true
    subscriptions: ->
      if @data? and @data()
        recommendation = @data()

        # Get first building in the list so we can find it's city id and load the corresponding city buildings.
        firstBuilding = Buildings.findOne(recommendation.buildingIds[0]) if recommendation.buildingIds
        # If there is a building, set the city id. If not, default to Atlanta for now.
        # In the future, a recommendation list might only be limited to one particular city.
        firstCityId = if firstBuilding then firstBuilding.cityId else 'atlanta'
        @params.cityId = if @params.query.cityId then @params.query.cityId else firstCityId
        subscriptionQuery = _.omit(@params.query, 'cityId')

        @subscribe("buildings", @params.cityId, subscriptionQuery, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1).wait()
        @subscribe("city-buildings-count", @params.cityId, subscriptionQuery).wait()

        (unitIds = recommendation.unitIds.map (value) -> value.unitId) if recommendation.unitIds?
        recommendedIds = recommendation.buildingIds.concat(unitIds) if recommendation.buildingIds?
        @subscribe("recommendedBuildings", recommendedIds).wait() if recommendedIds

    waitOn: ->
      Meteor.subscribe "singleClientRecommendation", @params.clientId
    data: ->  
      clientRecommendations = ClientRecommendations.findOne(@params.clientId)
      if clientRecommendations
        _.extend clientRecommendations, @params
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
      share.setPageTitle "Recommendations for #{@params.clientName}"
      @next()
    #   share.setPageTitle("Rental Apartments and Condos in " + cities[@params.cityId].long)
  @route "/city/:cityId",
    name: "city"
    fastRender: true
    subscriptions: ->
#      citySubsciption = Meteor.subscribe("buildings", @params.cityId, @params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
#      if Meteor.isClient
#        window.citySubsciption = citySubsciption
      [
        citySubs.subscribe("buildings", @params.cityId, @params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
        Meteor.subscribe("city-buildings-count", @params.cityId, @params.query)
      ]
    data: ->
      return null unless @params.cityId in cityIds
      @params
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
        Session.set("cityScroll", 0)
      share.setPageTitle("Rental Apartments and Condos in " + cities[@params.cityId].long)
      @next()
    onAfterAction: ->
      SEO.set
        meta:
          description: "Find a great apartment in #{cities[@params.cityId].short} with Rent Scene. View videos, photos, floor plans, and up-to-date pricing for thousands of units."
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
        buildingSubs.subscribe("vimeoVideos")
      ]
    data: ->
      # console.log("cityId: " + @params.cityId)
      # console.log("neighborhoodSlug: " + @params.neighborhoodSlug)
      # console.log("unitSlug: " + @params.unitSlug)
      # console.log("buildingSlug: " + @params.buildingSlug)
      building = Buildings.findOne({cityId: String(@params.cityId), slug: String(@params.unitSlug or @params.buildingSlug)})
      return null unless building
      _.extend {}, @params,
        building: building
    onAfterAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
      data = @data()
      building = data.building
      if building
        metaTags = building.metaTags()
        SEO.set
          title: metaTags.title
          meta:
            description: metaTags.description

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
