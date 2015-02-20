ContactUsRequests.allow
  insert: share.securityRulesWrapper (userId, request) ->
    checkLength(request, ["name", "email", "bedrooms"])
    cl request
    check(request,
      _id: Match.Id
      name: String
      email: String
      bedrooms: String
      maxMonthlyRent: String
      contactUsMoveInDate: String
      contactUsTourDate: String
      tourOption: String
      city: String
      yes: Boolean
      no: Boolean
      notSure: Boolean
      question: String
      userListId: String
      agentName: String
      agentId: String
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
