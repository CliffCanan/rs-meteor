@itemsPerPage = 24

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
  princeton:
    short: "Princeton"
    long: "PRINCETON, NJ"
    human: "Princeton, NJ"
    latitude: 40.35
    longitude: -74.67
  stamford:
    short: "Stamford"
    long: "STAMFORD, CT"
    human: "Stamford, CT"
    latitude: 41.05
    longitude: -73.54
  trenton:
    short: "Trenton"
    long: "TRENTON, NJ"
    human: "Trenton, NJ"
    latitude: 40.22
    longitude: -74.76
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

@btypes =
  studio:
    lower: "Studio"
    upper: "Studio"
  bedroom1:
    lower: "1 bedroom"
    upper: "1 Bedroom"
  bedroom2:
    lower: "2 bedrooms"
    upper: "2 Bedrooms"
  bedroom3:
    lower: "3 bedrooms"
    upper: "3 Bedrooms"
  bedroom4:
    lower: "4 bedrooms"
    upper: "4 Bedrooms"
  bedroom5:
    lower: "5 bedrooms"
    upper: "5 Bedrooms"


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

share.exitRecommendationsMode = () ->
  if Router.current().data
    Router.go "city", cityId: Router.current().data().cityId
  else
    Router.go "index"
  $('.typeahead').val null
  Session.set "recommendationsClientObject", null
  Session.set "showRecommendations", null
  return

if Meteor.isServer
  Meteor.methods
    "neighborhoodsList": ->
      Buildings.aggregate([
        # Group all properties by city, neighborhood, neighborhood slug and add a total number of properties for each group
        {$group: {_id: {city: '$cityId', neighborhood: '$neighborhood', neighborhoodSlug: '$neighborhoodSlug'}, count: { '$sum': 1 }}}
        # Sort by most properties first
        {$sort: {count: -1}}
        # Group them again by city, and have a neighborhoods array with name, slug
        {$group: {_id: '$_id.city', neighborhoods: {$push: {name: '$_id.neighborhood', slug: '$_id.neighborhoodSlug'}}}}
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
      results.neighborhoods
