CheckAvailabilityRequests.allow
  insert: share.securityRulesWrapper (userId, request) ->
    checkLength(request, ["name", "email", "moveInDate", "city", "buildingId"])
    check(request,
      _id: Match.Id
      name: String
      email: String
      phoneNumber: String
      moveInDate: String
      cityName: String
      cityId: String
      buildingName: String
      buildingId: String
      link: String
      question: String
      bedrooms: String
      updatedAt: Date
      createdAt: Date
      source: String
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
