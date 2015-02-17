@cities =
  atlanta: "ATLANTA, GA"
  boston: "BOSTON, MA"
  chicago: "CHICAGO, IL"
  "los-angeles": "LOS ANGELES, CA"
  philadelphia: "PHILADELPHIA, PA"
  stamford: "STAMFORD, CT"
  "washington-dc": "WASHINGTON, DC"

@citiesArray =
  for key, value of cities
    key: key
    value: value

@cityIds = Object.keys(cities)

@slugify = (text) ->
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
