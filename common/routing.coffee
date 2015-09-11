adminSubs = new SubsManager()
@citySubs = new SubsManager()
buildingSubs = new SubsManager()

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}

Router.plugin("dataNotFound", {notFoundTemplate: "notFound"})
Router.onBeforeAction ->
  if Meteor.user() and Meteor.user().role in ["admin", "super", "staff"]
    this.next()
  else
    this.render('notFound')
, only: ['adminReviews', 'adminRentalApplications']

Router.map ->
  @route "/",
    name: "index"
    onAfterAction: ->
      SEO.set
        title: share.formatPageTitle "Rent Scene - Apartments and Condos for Rent", false
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

        firstBuilding = Buildings.findOne(recommendation.buildingIds[0]) if recommendation.buildingIds
        firstCityId = if firstBuilding then firstBuilding.cityId else 'atlanta'
        @params.cityId = if @params.query.cityId then @params.query.cityId else firstCityId
        []

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
      @next()
    onAfterAction: ->
      SEO.set
        title: share.formatPageTitle "Recommendations for #{@data().name}"
        meta: 
          robots: "noindex"
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
      if @params.query.hasOwnProperty 'address'
        Session.set("cityName", @params.query.address)
      else
        if Session.get('enteredAddress')
          address = Session.get('enteredAddress')
          Session.set("cityName", address)
          Router.go("city", {cityId: @params.cityId}, {query: {address: address}})
        else
          Session.set("cityName", "")
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
        Session.set("cityScroll", 0)
      @next()
    onAfterAction: ->
      SEO.set
        title: share.formatPageTitle "Rental Apartments and Condos in #{cities[@params.cityId].long}"
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
        buildingSubs.subscribe("buildingsSimilar", @params.cityId, @params.unitSlug or @params.buildingSlug)
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
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
      @next()
    onAfterAction: ->
      building = @data().building
      metaTags = building.metaTags()
      if metaTags.title
        SEO.set
          title: metaTags.title
          meta:
            description: metaTags.description

  @route "/rental-application",
    name: "newRentalApplication"
    action: ->
      newRentalApplication =
        createdAt: new Date()
        status: 'New'

      newRentalApplication.buildingId = @params.query.buildingId if @params.query.buildingId

      insertedId = RentalApplications.insert newRentalApplication
      Router.go('rentalApplication', {id: insertedId}, {replaceState: true})
  
  @route "/rental-application/:id",
    name: "rentalApplication"
    waitOn: ->
      accessToken = Session.get('rentalApplicationAccessToken')
      Meteor.subscribe('rentalApplication', @params.id, accessToken)
    data: ->
      RentalApplications.findOne(@params.id)

  @route "/rental-application/:id/download", ->
    rentalApplication = RentalApplications.findOne(@params.id)
    template = Assets.getText('rental-application-pdf.html')

    SSR.compileTemplate('rentalApplicationPDF', template)

    Template.rentalApplicationPDF.helpers
      "renderDate": (date) ->
        moment(date).format("MM/DD/YYYY")

      "getReadableShortDate": (date) ->
        moment(date).format('D MMM YY')

      "getReadableLongDate": (date) ->
        moment(date).format('Do MMMM YYYY')

      "getReadableShortDateTime": (date) ->
        moment(date).format('h:mma, D MMM YY')

      "getReadableLongDateTime": (date) ->
        moment(date).format('h:mma, Do MMMM YYYY')

      "signatureData": ->
        @signature.svgbase64[1]

    html = SSR.render('rentalApplicationPDF', rentalApplication)

    res = @response
    stream = wkhtmltopdf(html, viewportSize: '1200x768', (code, signal) ->
    ).pipe(res)

  , where: 'server'

  @route "admin/rental-applications",
    name: "adminRentalApplications"
    waitOn: ->
      Meteor.subscribe('rentalApplications')
    data: ->
      RentalApplications.find()
    onAfterAction: ->
      SEO.set
        title: 'Admin: Manage Rental Applications | Rent Scene'

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
  @route "/admin/reviews",
    name: "adminReviews"
    waitOn: ->
      Meteor.subscribe("pendingReviews")
      

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

share.formatPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " | Rent Scene"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  title
