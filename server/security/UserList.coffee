UserLists.allow
  insert: share.securityRulesWrapper (userId, request) ->
    true
  update: share.securityRulesWrapper (userId, request, fieldNames, modifier, options) ->
    unless userId
      false
    true
  remove: share.securityRulesWrapper (userId, request) ->
    false
  fetch: ['_id']

