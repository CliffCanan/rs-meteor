@itemsPerPage = 60

@cities =
  atlanta:
    short: "Atlanta"
    long: "ATLANTA, GA"
    latitude: 33.75
    longitude: -84.39
  boston:
    short: "Boston"
    long: "BOSTON, MA"
    latitude: 42.36
    longitude: -71.06
  chicago:
    short: "Chicago"
    long: "CHICAGO, IL"
    latitude: 41.88
    longitude: -87.63
  "los-angeles":
    short: "Los Angeles"
    long: "LOS ANGELES, CA"
    latitude: 34.05
    longitude: -118.24
  philadelphia:
    short: "Philadelphia"
    long: "PHILADELPHIA, PA"
    latitude: 39.95
    longitude: -75.17
  stamford:
    short: "Stamford"
    long: "STAMFORD, CT"
    latitude: 41.05
    longitude: -73.54
  "washington-dc":
    short: "Washington"
    long: "WASHINGTON, DC"
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

@slugify = (text) ->
  return "" unless text?.length
  text.toString().toLowerCase()
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

share.isDebug = Meteor.settings.public.isDebug

object = if typeof(window) != "undefined" then window else GLOBAL
object.isDebug = share.isDebug
if typeof(console) != "undefined" && console.log && _.isFunction(console.log)
  object.cl = _.bind(console.log, console)
else
  object.cl = ->
