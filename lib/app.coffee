@cities =
  atlanta: "ATLANTA, GA"
  boston: "BOSTON, MA"
  chicago: "CHICAGO, IL"
  "los-angeles": "LOS ANGELES, CA"
  philadelphia: "PHILADELPHIA, PA"
  stamford: "STAMFORD, CT"
  washington: "WASHINGTON, DC"

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
