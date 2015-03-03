Meteor.users.allow
  insert: share.securityRulesWrapper (userId, user) ->
    false
  update: share.securityRulesWrapper (userId, user, fieldNames, modifier, options) ->
    if userId
      if "role" in fieldNames
        if Meteor.user().role is "super"
          return true
        else if Meteor.user().role is "admin"
          return modifier.$set.role isnt "super"
        else
          return false
      else
        return user._id is userId
    else
      return false

  remove: share.securityRulesWrapper (userId, user) ->
    false
  fetch: ['_id']
