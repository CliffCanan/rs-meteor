@cities =
  atlanta:
    short: "Atlanta"
    long: "ATLANTA, GA"
  boston:
    short: "Boston"
    long: "BOSTON, MA"
  chicago:
    short: "Chicago"
    long: "CHICAGO, IL"
  "los-angeles":
    short: "Los Angeles"
    long: "LOS ANGELES, CA"
  philadelphia:
    short: "Philadelphia"
    long: "PHILADELPHIA, PA"
  stamford:
    short: "Stamford"
    long: "STAMFORD, CT"
  "washington-dc":
    short: "Washington"
    long: "WASHINGTON, DC"

@citiesArray =
  for key, value of cities
    key: key
    value: value.long

@cityIds = Object.keys(cities)

@btypes =
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
  studio:
    lower: "studio"
    upper: "Studio"

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
