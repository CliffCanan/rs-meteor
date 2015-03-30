share.securityRulesWrapper = (func) ->
  return ->
    try
      return func.apply(@, arguments)
    catch exception
      Meteor._debug(exception)
      Meteor._debug(arguments)
      throw exception
