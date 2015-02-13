Meteor.users.allow
  insert: share.securityRulesWrapper (userId, user) ->
    false
  update: share.securityRulesWrapper (userId, user, fieldNames, modifier, options) ->
    user._id is userId
  remove: share.securityRulesWrapper (userId, user) ->
    false
  fetch: ['_id']
