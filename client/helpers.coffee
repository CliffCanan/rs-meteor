UI.registerHelper("share", ->
  share
)

UI.registerHelper("Settings", ->
  Meteor.settings
)

UI.registerHelper("Router", ->
  Router
)

UI.registerHelper "Session", (key) ->
  Session.get(key)

UI.registerHelper "SessionEquals", (key, value) ->
  Session.equals(key, value)

UI.registerHelper "currentUserId", ->
  Meteor.userId()

UI.registerHelper("condition", (v1, operator, v2, options) ->
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
)

UI.registerHelper("not", (value) ->
  not value
)

UI.registerHelper("key_value", (object, keyKey, valueKey, hash) ->
  for key, value of object
    result = {}
    result[keyKey] = key
    result[valueKey] = value
    result
)

UI.registerHelper("momentFromNow", (date) ->
  moment(date).fromNow()
)

UI.registerHelper("encodeURIComponent", (value) ->
  encodeURIComponent(value)
)

UI.registerHelper("currentUserEmail", ->
  Meteor.user().emails[0].address
)

UI.registerHelper("currentUrl", ->
  location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + Iron.Location.get().path
)

UI.registerHelper("_", (key, hash) ->
  params = {} # default
  params = hash.hash  if hash
  result = i18n.t(key, params)
  new Spacebars.SafeString(result)
)

UI.registerHelper("isEmpty", (object, hash) ->
  _.isEmpty(object)
)
