ContactUsRequests.allow
  insert: share.securityRulesWrapper (userId, request) ->
    checkLength(request, ["name", "email", "bedrooms"])
    check(request,
      name: String
      email: String
      phoneNumber: String
      #bedrooms: String
      maxMonthlyRent: String
      contactUsMoveInDate: String
      #contactUsTourDate: String
      #tourOption: String
      cityName: String
      cityId: String
      #yes: Boolean
      #no: Boolean
      #notSure: Boolean
      question: String
      source: String
      medium: String
      campaign: String
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
