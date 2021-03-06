@itemsPerPage = 12

@cities =
  # atlanta:
  #   short: "Atlanta"
  #   long: "ATLANTA, GA"
  #   human: "Atlanta, GA"
  #   latitude: 33.75
  #   longitude: -84.39
  # boston:
  #   short: "Boston"
  #   long: "BOSTON, MA"
  #   human: "Boston, MA"
  #   latitude: 42.36
  #   longitude: -71.06
  chicago:
    short: "Chicago"
    long: "CHICAGO, IL"
    human: "Chicago, IL"
    latitude: 41.88
    longitude: -87.63
  # "los-angeles":
  #   short: "Los Angeles"
  #   long: "LOS ANGELES, CA"
  #   human: "Los Angeles, CA"
  #   latitude: 34.05
  #   longitude: -118.24
  philadelphia:
    short: "Philadelphia"
    long: "PHILADELPHIA, PA"
    human: "Philadelphia, PA"
    latitude: 39.95
    longitude: -75.17
  stamford:
    short: "Stamford"
    long: "STAMFORD, CT"
    human: "Stamford, CT"
    latitude: 41.05
    longitude: -73.54
  "washington-dc":
    short: "Washington"
    long: "WASHINGTON, DC"
    human: "Washington, DC"
    latitude: 38.90
    longitude: -77.04

@citiesArray =
  for key, value of cities
    key: key
    value: value.long

@cityIds = Object.keys(cities)

@mapBoundsDefaults =
  latitudeMin: null
  longitudeMin: null
  latitudeMax: null
  longitudeMax: null

@mapBounds = _.extend({}, @mapBoundsDefaults)

@resetMapBounds = ->
  _.extend(mapBounds, mapBoundsDefaults)
  mapBoundsDependency.changed()

@btypes =
  studio:
    lower: "Studio"
    upper: "Studio"
#  bedroom0:
#    lower: "0 BR"
#    upper: "0 Bedroom"
  bedroom1:
    lower: "1 BR"
    upper: "1 Bedroom"
  bedroom2:
    lower: "2 BR"
    upper: "2 Bedrooms"
  bedroom3:
    lower: "3 BR"
    upper: "3 Bedrooms"
  bedroom4:
    lower: "4 BR"
    upper: "4 Bedrooms"


@btypesArray =
  for key, value of btypes
    key: key
    value: value.lower

@btypesIds = Object.keys(btypes)

@adminFields = [
  "adminAvailability"
  "adminEscorted"
  "adminAppFee"
  "adminOfficeHours"
  "adminScheduling"
  "adminContact"
  "adminNotes"
]

@vimeoThumbnailSizes =
  xxs: '100x75'
  xs: '200x150'
  s: '295x166'
  m: '640x360'
  l: '960x540'
  xl: '1280x720'

@slugify = (text) ->
  text = text.toString().toLowerCase()
  unless text?.length
    text = "item"
  text
  .replace(/\s+/g, '-')# Replace spaces with -
  .replace(/[^\w\-]+/g, '')# Remove all non - word chars
  .replace(/\-\-+/g, '-')# Replace multiple - with single -
  .replace(/^-+/, '')# Trim - from start of text
  .replace(/-+$/, '') # Trim - from end of text

share = share or {}

#share.combine = (funcs...) ->
#  (args...) =>
#    for func in funcs
#      func.apply(@, args)

share.user = (fields, userId = Meteor.userId()) ->
  Meteor.users.findOne(userId, {fields: fields})

share.intval = (value) ->
  parseInt(value, 10) || 0

share.floatval = (value) ->
  parseFloat(value) || 0

share.getThumbnail = (store) ->
  if @ instanceof FS.File
    params =
      store: store.hash.store
      auth: false
    return @url params
  return @thumbnail.replace(vimeoThumbnailSizes.s, vimeoThumbnailSizes.m)

share.isDebug = Meteor.settings.public.isDebug

object = if typeof(window) != "undefined" then window else GLOBAL
object.isDebug = share.isDebug
if typeof(console) != "undefined" && console.log && _.isFunction(console.log)
  object.cl = _.bind(console.log, console)
else
  object.cl = ->

share.canRecommend = () ->
  Session.get("recommendationsClientObject") and Security.canManageClients()

share.showClientRecommendationsBar = () ->
  Session.get("recommendationsClientObject") and not Security.canManageClients() and (Router.current().route.getName() isnt "clientRecommendations")

share.exitRecommendationsMode = () ->
  client = Session.get("recommendationsClientObject")

  swal
    title: "Send Recommendation Email To Client?"
    text: "Do you want to send the Client Recommendation Email to #{client.name}?"
    type: "warning"
    confirmButtonColor: "#4588fa"
    confirmButtonText: "Yes"
    showCancelButton: true
    cancelButtonText: "No"
    showLoaderOnConfirm: true
    html: true
    , (isConfirm) ->
      if isConfirm
        client = Session.get("recommendationsClientObject") # avoid outer closure

        name = client.name
        email = client.email
        if email
          id = client._id
          Meteor.call "sendRecommendationEmail", id, (error) ->
            if error
              console.log 'Error has been returned from "sendRecommendationEmail"', error
              share.notifyRecommendationsEmailError name
            else
              share.notifyRecommendationsSuccessfullySent name
        else 
          $('#email-sending-popup').modal('show')
      else
        share.redirectFromRecommendationsMode()

share.notifyRecommendationsSuccessfullySent = (name) ->
  share.redirectFromRecommendationsMode()
  toastr.success "Email sent successfully to #{name}"

share.notifyRecommendationsEmailError = (name) ->
  #share.redirectFromRecommendationsMode()
  toastr.error "Email to #{name} couldn't be sent because of server error"

share.redirectFromRecommendationsMode = ->
  if Router.current().data
    Router.go "city", cityId: Router.current().data().cityId
  else
    Router.go "index"
  $('.typeahead').val null
  Session.set "recommendationsClientObject", null
  Session.set "showRecommendations", null
  Session.set 'clientId', null

if Meteor.isServer
  Meteor.methods
    "neighborhoodsList": ->
      selector = {parentId: {$exists: false}, images: {$exists: true, $ne: []}}
      selector.isPublished = true if not (Meteor.userId() and Security.canOperateWithBuilding(Meteor.userId()))

      Buildings.aggregate([
        {$match: selector}
        # Group all properties by city, neighborhood slug and add a total number of properties for each group
        {$group: {_id: {city: '$cityId', neighborhood: '$neighborhood', neighborhoodSlug: '$neighborhoodSlug'}, count: { '$sum': 1 }}}
        # Sort by most properties first
        {$sort: {neighborhood: -1}}
        # Group them again by city, and have a neighborhoods array with name, slug
        {$group: {_id: '$_id.city', neighborhoods: {$push: {name: '$_id.neighborhood', slug: '$_id.neighborhoodSlug', count: '$count'}}}}
      ])

@neighborhoodsList = {}
context = @

Meteor.call "neighborhoodsList", (err, result) ->
  neighborhoodsList = _.map result, (values, key) ->
    cityId: values._id
    neighborhoods: values.neighborhoods
  context.neighborhoodsList = neighborhoodsList
  neighborhoodsListFlattened = _.flatten(_.pluck(neighborhoodsList, 'neighborhoods'))
  context.neighborhoodsListRaw = _.object(_.pluck(neighborhoodsListFlattened, 'slug'), _.pluck(neighborhoodsListFlattened, 'name'))

share.neighborhoodsInCity = (cityId) ->
  if context.neighborhoodsList? and context.neighborhoodsList

    results = _.findWhere(context.neighborhoodsList, {cityId: cityId})

    if results
      filteredResults = _.reject(results.neighborhoods, (n) ->
        n.name.trim() is "" or n.name.trim() is "None Available" #or n.length > 1
      )
      filteredResults
