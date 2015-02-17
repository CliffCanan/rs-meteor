CheckAvailabilityRequests.allow
  insert: share.securityRulesWrapper (userId, request) ->
    checkLength(request, ["name", "email", "moveInDate", "city", "property"])
    check(request,
      _id: Match.Id
      name: String
      email: String
      moveInDate: String
      city: String
      property: String
      question: String
      updatedAt: Date
      createdAt: Date
    )
    true
  update: share.securityRulesWrapper (userId, request, fieldNames, modifier, options) ->
    false
  remove: share.securityRulesWrapper (userId, request) ->
    false
  fetch: ['_id']

checkLength = (request, properties) ->
  for property in properties
    if request[property]?.length is 0
      throw new Match.Error("Request field '"+property+"' shouldn't be empty")
