ContactUsRequests.allow
  insert: share.securityRulesWrapper (userId, request) ->
    true
  update: share.securityRulesWrapper (userId, request, fieldNames, modifier, options) ->
    false
  remove: share.securityRulesWrapper (userId, request) ->
    false
  fetch: ['_id']