Meteor.users.allow
  insert: share.securityRulesWrapper (userId, user) ->
    false
  update: share.securityRulesWrapper (userId, user, fieldNames, modifier, options) ->
    user._id is userId or user.role in ["admin", "super"]
  remove: share.securityRulesWrapper (userId, user) ->
    false
  fetch: ['_id']
