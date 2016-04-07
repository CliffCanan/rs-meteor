adminSubs = new SubsManager()
@citySubs = new SubsManager()
buildingSubs = new SubsManager()

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}
    "footer": {to: "footer"}

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
    fastRender: true
    onBeforeAction: ->

      Session.setDefault('hasAlrdyConverted', false);

      source = (if @params.query.utm_source then @params.query.utm_source else "no source found")
      medium = (if @params.query.utm_medium then @params.query.utm_medium else "no medium found")
      campaign = (if @params.query.utm_campaign then @params.query.utm_campaign else "no campaign found")

      if source is "no source found"
        # 'gclid' is appended by Google AdWords to auto-map the user in AdWords and Analytics
        source = (if @params.query.gclid then "AdWords Campaign" else "no source found")

      if @params.query.fb and @params.query.fb = true
        source = "Facebook Ad"

      Session.set "utm_source", source
      Session.set "utm_medium", medium
      Session.set "utm_campaign", campaign

      @next()
    onAfterAction: ->
      Session.set "currentPage", "home"
      SEO.set
        title: "Rent Scene | Apartment Hunting For Busy People"
        meta:
          description: "Rent Scene finds the best apartments that fit your lifestyle. Our dedicated local experts manage the entire search process for you, making sure you love your new home."
          keywords: "rent,rental,apartment,tenant,bedroom,bathroom,lease,luxury,condo,condominium,philadelphia,philly,center city,chicago,washington dc,rittenhouse square,parking,gym,utilities,pets,affordable"

  @route "/check-availability",
    name: "checkAvailability"

  #@route "/tour-signup",
  #  name: "tourSignup"

  @route "/login",
    name: "login"
    onBeforeAction: ->
      @next()
    onAfterAction: ->
      SEO.set
        title: "Rent Scene Admin Login"
        meta:
          robots: "noindex"

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
    waitOn: ->
      Meteor.subscribe "singleClientRecommendation", @params.clientId
    data: ->  
      recommendation = ClientRecommendations.findOne(@params.clientId)
      if recommendation
        firstBuilding = Buildings.findOne(recommendation.buildingIds[0]) if recommendation.buildingIds
        firstCityId = if firstBuilding then firstBuilding.cityId else 'philadelphia'
        @params.cityId = if @params.query.cityId then @params.query.cityId else firstCityId
        _.extend recommendation, @params
        recommendation
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})
      @next()
    onAfterAction: ->
      SEO.set
        title: "Apartment Recommendations for #{@data().name}"
        meta: 
          robots: "noindex"

  @route "/city/:cityId?",
    name: "city"
    fastRender: true
    subscriptions: ->
      [
        citySubs.subscribe("buildings", @params.cityId, @params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1)
        Meteor.subscribe("city-buildings-count", @params.cityId, @params.query)
      ]
    data: ->
      return null unless @params.cityId in cityIds
      @params
    onBeforeAction: ->
      Session.set("currentNeighborhood", undefined)

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

      Session.setDefault('hasAlrdyConverted', false);
      Session.setDefault('utm_source', 'no source found');
      Session.setDefault('utm_medium', 'no medium found');
      Session.setDefault('utm_campaign', 'no campaign found');

      source = (if @params.query.utm_source then @params.query.utm_source else "no source found")
      medium = (if @params.query.utm_medium then @params.query.utm_medium else "no medium found")
      campaign = (if @params.query.utm_campaign then @params.query.utm_campaign else "no campaign found")

      if source is "no source found"
        # 'gclid' is appended by Google AdWords to auto-map the user in AdWords and Analytics
        source = if @params.query.gclid then "AdWords Campaign" else "no source found"

      if @params.query.fb and @params.query.fb is true
        source = "Facebook Ad"

      Session.set "utm_source", source  unless source is "no source found"
      Session.set "utm_medium", medium  unless medium is "no medium found"
      Session.set "utm_campaign", campaign  unless campaign is "no campaign found"

      @next()
    onAfterAction: ->
      Session.set "currentPage", "city"
      SEO.set
        title: "Rental Apartments in #{cities[@params.cityId].human} | Rent Scene"
        meta:
          description: "Find a great apartment in #{cities[@params.cityId].short} with Rent Scene. View videos, photos, floor plans, and up-to-date pricing for thousands of affordable luxury units."
          keywords: "rent,rental,#{cities[@params.cityId].short},luxury,affordable,bedroom,laundry,garage,doorman,parking,amenities"

  @route "/city/:cityId/:neighborhoodSlug?",
    name: "neighborhood"
    fastRender: true
    subscriptions: ->
      # We need to clone the property or it will be passed by reference
      query = _.clone(@params.query)
      query.neighborhoodSlug = @params.neighborhoodSlug
      [
        citySubs.subscribe("buildings", @params.cityId, query, if Meteor.isClient then Session.get("neighborhoodPageData")?.page or 1 else 1)
        Meteor.subscribe("city-buildings-count", @params.cityId, query)
      ]
    data: ->
      return null unless @params.cityId in cityIds
      @params
    onBeforeAction: ->
      currentHood = if @params.neighborhoodSlug then @params.neighborhoodSlug else undefined
      Session.set("currentNeighborhood", currentHood)

      Session.set("neighborhoodPageData", {page: 1})
      Session.set("cityPageData", {cityId: @params.cityId, page: 1})
      Session.set("cityScroll", 0)

      Session.setDefault('hasAlrdyConverted', false);
      Session.setDefault('utm_source', 'no source found');
      Session.setDefault('utm_medium', 'no medium found');
      Session.setDefault('utm_campaign', 'no campaign found');

      source = (if @params.query.utm_source then @params.query.utm_source else "no source found")
      medium = (if @params.query.utm_medium then @params.query.utm_medium else "no medium found")
      campaign = (if @params.query.utm_campaign then @params.query.utm_campaign else "no campaign found")

      if source is "no source found"
        # 'gclid' is appended by Google AdWords to auto-map the user in AdWords and Analytics
        source = (if @params.query.gclid then "AdWords Campaign" else "no source found")

      if @params.query.fb and @params.query.fb = true
        source = "Facebook Ad"

      Session.set "utm_source", source  unless source is "no source found"
      Session.set "utm_medium", medium  unless medium is "no medium found"
      Session.set "utm_campaign", campaign  unless campaign is "no campaign found"

      @next()
    onAfterAction: ->
      Session.set "currentPage", "neighborhood"
      SEO.set
        title: "Rent Apartments in #{cities[@params.cityId].human} | Rent Scene"
        meta:
          description: "Find a great apartment in #{cities[@params.cityId].short} with Rent Scene. View videos and photos, schedule tours, and check out up-to-date pricing for thousands of #{cities[@params.cityId].short}'s best units."

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
      building = Buildings.findOne({cityId: String(@params.cityId), slug: String(@params.unitSlug or @params.buildingSlug)})
      return null unless building
      _.extend {}, @params,
        building: building
    onBeforeAction: ->
      oldData = Session.get("cityPageData")
      if oldData?.cityId isnt @params.cityId
        Session.set("cityPageData", {cityId: @params.cityId, page: 1})

      Session.setDefault('hasAlrdyConverted', false);
      Session.setDefault('utm_source', 'no source found');
      Session.setDefault('utm_medium', 'no medium found');
      Session.setDefault('utm_campaign', 'no campaign found');

      source = (if @params.query.utm_source then @params.query.utm_source else "no source found")
      medium = (if @params.query.utm_medium then @params.query.utm_medium else "no medium found")
      campaign = (if @params.query.utm_campaign then @params.query.utm_campaign else "no campaign found")

      if source is "no source found"
        # 'gclid' is appended by Google AdWords to auto-map the user in AdWords and Analytics
        source = (if @params.query.gclid then "AdWords Campaign" else "no source found")

      if @params.query.fb and @params.query.fb = true
        source = "Facebook Ad"

      Session.set "utm_source", source  unless source is "no source found"
      Session.set "utm_medium", medium  unless medium is "no medium found"
      Session.set "utm_campaign", campaign  unless campaign is "no campaign found"

      @next()
    onAfterAction: ->
      Session.set "currentPage", "building"

      if @data() and @data().building
        building = @data().building
        metaTags = building.metaTags()

        #console.log(metaTags)
        #console.log(metaTags.title)

        if metaTags.title
          #console.log("Routing -> building -> onAfterAction -> metaTags.Title EXISTS")
          SEO.set
            title: metaTags.title
            meta:
              description: metaTags.description
        else
          #console.log("Routing -> building -> onAfterAction -> metaTags.Title DOES NOT EXIST")
      else
        console.log("Routing -> building -> onAfterAction #261")
        SEO.set
          title: "#{cities[@params.cityId].short} Apartment | Rent Scene"

  @route "/apply",
    name: "newRentalApplication"
    action: ->
      newRentalApplication =
        createdAt: new Date()
        status: 'New'

      if @params.query.buildingId
        unit = Buildings.findOne(@params.query.buildingId)

        if unit
          newRentalApplication.buildingId = unit._id
          newRentalApplication.fields =
            apartmentName: unit.title

      insertedId = RentalApplications.insert newRentalApplication
      Router.go('rentalApplication', {id: insertedId}, {replaceState: true})
    onAfterAction: ->
      SEO.set
        title: 'Rental Application | Rent Scene'
  
  @route "/apply/:id",
    name: "rentalApplication"
    waitOn: ->
      accessToken = Session.get('rentalApplicationAccessToken')
      Meteor.subscribe('rentalApplication', @params.id, accessToken)
    data: ->
      RentalApplications.findOne(@params.id)
    onAfterAction: ->
      SEO.set
        title: 'Rental Application | Rent Scene'
        meta:
          robots: "noindex"

  @route "/apply/:id/download", ->
    rentalApplication = RentalApplications.findOne(@params.id)

    template = Assets.getText('rental-application-pdf.html')

    # Compile template using Server Side Render package
    SSR.compileTemplate('rentalApplicationPDF', template)

    # Define all helpers
    Template.rentalApplicationPDF.helpers
      "checkEquals": (v1, v2) ->
        v1 is v2

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

      "formatMoney": (value) ->
        value.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,') if value

      "showPreviousAddress": ->
        return @fields.previousAddress and (@fields.previousAddressDuration isnt '12+ months' and @fields.previousAddressDuration isnt '12 months' and @fields.previousAddressDuration isnt 'N/A')

      "signatureData": ->
        if @signature and @signature.svgbase64
          @signature.svgbase64[1]

      "showCriminalHistoryExplanation": ->
        if @fields.hasFiledForBankruptcy is 'Yes' or @fields.hasBeenEvicted is 'Yes' or @fields.hasRefusedToPayRent is 'Yes' or @fields.hasViolatedOrBrokenAnyLeaseAgreement is 'Yes' or @fields.hasACriminalHistory is 'Yes' or @fields.hasPendingCase is 'Yes' or @fields.isRegisteredSexOffender is 'Yes'
          return true
        else
          return false

      # Base URL seems to be required so images can be loaded via absolute paths
      "baseUrl": ->
        # Return root URL with trailing slash removed
        # CLIFF (3/13/16): this wasn't actually removing a trailing slash, it was removing the 'm'
        # from the BaseURL of '...rentscene.com', which caused the image to not be displayed in the generated .PDF.
        # Leaving this comment in case the issue comes up again and the trailing slash re-appears.
        process.env.ROOT_URL #.slice(0, -1)

      "documents": ->
        result = []
        if @documents
          for document in @documents
            loadedDocument = document.getFileRecord()
            if loadedDocument instanceof FS.File and loadedDocument.isImage()
              console.log("Document found, checkpoint reached!")
              result.push(loadedDocument)

        result

    # Get rendered HTML with the current rental application object passed in
    html = SSR.render('rentalApplicationPDF', rentalApplication)

    res = @response
    res.setHeader('Content-disposition', "attachment; filename=RentScene_RentalApplication_#{rentalApplication.fields.fullName}.pdf");

    fs = Npm.require('fs')

    # Start wkhtmltopdf to process the HTML, with a bigger viewport so the form layout is mantained
    stream = wkhtmltopdf(html, viewportSize: '1200x768')

    # PDF(s) that are uploaded to the application can only be appended together with the pdftk package. Let's look at each uploaded
    # document to see if we have PDF documents

    # 'Hardcode' the base path for CollectionFS documents for now since there is no official function to do it.
    basePath = fs.realpathSync(process.cwd() + '/../../..') + '/cfs/files/rentalApplicationDocuments'

    hasPDF = false
    if rentalApplication.documents
      pdfCatJoinArgs = []
      for document in rentalApplication.documents
        loadedDocument = document.getFileRecord()
        if loadedDocument.type() is 'application/pdf'
          # Yeap, PDF found. Push the absolute path of the PDF into the arguments array.
          filename = loadedDocument.copies['rentalApplicationDocuments'].key
          pdfCatJoinArgs.push "#{basePath}/#{filename}"

      if pdfCatJoinArgs.length
        # pdftk takes has the following arguments: [inputFilepath1, inputFilepath2, ..., 'cat', 'output', outputFilepath]
        # For the first PDF file, we'll create a temporary PDF from wkhtmltopdf's output
        pdfTempFile = "/tmp/#{@params.id}.pdf"
        pdfJoinedTempFile = "/tmp/#{@params.id}-joined.pdf"
        pdfCatPrefixArgs = [pdfTempFile]
        pdfCatSuffixArgs = ['cat', 'output', pdfJoinedTempFile]

        pdfCatArgs = pdfCatPrefixArgs.concat(pdfCatJoinArgs, pdfCatSuffixArgs)

        # Pipe the wkhtmltopdf out to the temp file and when it's done, run pdftk to concat uploaded PDFs at the end of the document
        fileEvent = stream.pipe(fs.createWriteStream(pdfTempFile))
        fileEvent.on 'finish', Meteor.bindEnvironment -> 
          PDFTK.execute(pdfCatArgs)
          # When pdftk is done, read the final joined PDF file and pipe it to the route's response to have it displayed in the browser
          fs.createReadStream(pdfJoinedTempFile).pipe(res)

        hasPDF = true
    
    # Or if there is not uploaded PDFs, pipe wkhtmltopdf to the browser
    stream.pipe(res) if not hasPDF

  , where: 'server'


  @route "/admin",
    name: "admin"
    onBeforeAction: ->
      Router.go("login")
    onAfterAction: ->
      SEO.set
        title: "Rent Scene Admin"
        meta:
          robots: "noindex"

  @route "admin/rental-applications",
    name: "adminRentalApplications"
    waitOn: ->
      Meteor.subscribe('rentalApplications')
    data: ->
      RentalApplications.find()
    onAfterAction: ->
      SEO.set
        title: 'Admin: Manage Rental Applications | Rent Scene'
        meta:
          robots: "noindex"

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
    onAfterAction: ->
      SEO.set
        title: 'Admin: Manage Users | Rent Scene'
        meta:
          robots: "noindex"

  @route "/admin/reviews",
    name: "adminReviews"
    waitOn: ->
      Meteor.subscribe("pendingReviews")
    onAfterAction: ->
      SEO.set
        title: 'Admin: Manage Apartment Reviews | Rent Scene'
        meta:
          robots: "noindex"

  @route "/featured-props",
    name: "featuredProps"
    #data: ->
      #building = Buildings.findOne({cityId: "philadelphia", slug: "2040-market-st"})
      #return null unless building
      #_.extend {}, @params,
      #  building: building
    onAfterAction: ->
      SEO.set
        title: 'Featured Listings | Rent Scene'    

  @route "/neighborhoods",
    name: "neighborhoods"
    onAfterAction: ->
      SEO.set
        title: 'Center City East | Rent Scene' 

  @route "/faq",
    name: "faq"
    onAfterAction: ->
      SEO.set
        title: 'Frequently Asked Questions | FAQ Rent Scene' 

  @route "/discovery",
    name: "discovery"
    onBeforeAction: ->
      Session.set "shouldHideFooter", true

      fname = if @params.query.fname then @params.query.fname else "there"
      lname = if @params.query.lname then @params.query.lname else "No Last Name"
      email = if @params.query.email and @params.query.email.indexOf("@") > 2 then @params.query.email else "form-default@nooch.com"

      Session.set "disc_fname", fname
      Session.set "disc_lname", lname
      Session.set "disc_email", email

      @next()
    onAfterAction: ->
      SEO.set
        title: 'Apartment Discovery Form | Rent Scene'
        meta:
          robots: "noindex"

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

# CC (2/4/15): This function isn't really necessary... so the ' | Rent Scene' is now directly included in the Title value for each route above.
share.formatPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " | Rent Scene"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  title
