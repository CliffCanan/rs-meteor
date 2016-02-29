Template.registerHelper "share", ->
  share

Template.registerHelper "Settings", ->
  Meteor.settings

Template.registerHelper "Router", ->
  Router

Template.registerHelper "Session", (key) ->
  Session.get(key)

Template.registerHelper "SessionEquals", (key, value) ->
  Session.equals(key, value)

Template.registerHelper "currentUserId", ->
  Meteor.userId()

Template.registerHelper "getFormatted", (date) ->
  date.getMonth() + "/" + date.getDate() + "/" +date.getFullYear()

Template.registerHelper "getReadableShortDate", (date) ->
  moment(date).format('D MMM YY')

Template.registerHelper "getReadableLongDate", (date) ->
  moment(date).format('Do MMMM YYYY')

Template.registerHelper "getReadableShortDateTime", (date) ->
  moment(date).format('h:mma, D MMM YY')

Template.registerHelper "getReadableLongDateTime", (date) ->
  moment(date).format('h:mma, Do MMMM YYYY')

Template.registerHelper "getReadableLongDateTimeAlt", (date) ->
  moment(date).format('MMM D, YYYY  |  h:mma')

Template.registerHelper "getUser", (userId) ->
  user = Meteor.users.findOne(userId)
  if user
    Meteor.users.findOne(userId).profile.name

Template.registerHelper "condition", (v1, operator, v2, options) ->
  switch operator
    when "==", "eq", "is"
      v1 is v2
    when "!=", "neq", "isnt"
      v1 isnt v2
    when "===", "ideq"
      v1 is v2
    when "!==", "nideq"
      v1 isnt v2
    when "&&", "and"
      v1 and v2
    when "||", "or"
      v1 or v2
    when "<", "lt"
      v1 < v2
    when "<=", "lte"
      v1 <= v2
    when ">", "gt"
      v1 > v2
    when ">=", "gte"
      v1 >= v2
    when "in"
      v2 = if _.isArray(v2) then v2 else Array.prototype.slice.call(arguments, 2, arguments.length - 1)
      v1 in v2
    when "not in", "nin"
      v2 = if _.isArray(v2) then v2 else Array.prototype.slice.call(arguments, 2, arguments.length - 1)
      v1 not in v2
    else
      throw "Undefined operator \"" + operator + "\""

Template.registerHelper "not", (value) ->
  not value

Template.registerHelper "key_value", (object, keyKey, valueKey, hash) ->
  for key, value of object
    result = {}
    result[keyKey] = key
    result[valueKey] = value
    result

Template.registerHelper "momentFromNow", (date) ->
  moment(date).fromNow()

Template.registerHelper "moment", (date, format) ->
  moment(date).format(format)

Template.registerHelper "encodeURIComponent", (value) ->
  encodeURIComponent(value)

Template.registerHelper "currentUserEmail", ->
  Meteor.user().emails[0].address

Template.registerHelper "currentUrl", ->
  location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + Iron.Location.get().path

Template.registerHelper "_", (key, hash) ->
  params = {} # default
  params = hash.hash  if hash
  result = i18n.t(key, params)
  new Spacebars.SafeString(result)

Template.registerHelper "isEmpty", (object, hash) ->
  _.isEmpty(object)

Template.registerHelper "isNotNullOrUndefined", (value, hash) ->
  value?

Template.registerHelper "cities", ->
  citiesArray

Template.registerHelper "btypes", ->
  btypesArray

Template.registerHelper "canOperateWithBuilding", ->
  Security.canOperateWithBuilding()

Template.registerHelper "canManageClients", ->
  Security.canManageClients()

Template.registerHelper "canRecommend", ->
  Session.get("recommendationsClientObject") and Security.canManageClients()

Template.registerHelper "currentClientName", ->
  if Session.get("recommendationsClientObject")
    clientObject = Session.get("recommendationsClientObject")
    clientObject.name

Template.registerHelper "clientRecommendationsList", ->
  if Router.current().route.getName() is "clientRecommendations"
    return true
  false
