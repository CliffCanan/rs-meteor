emails =
  atlanta: "team@rentscene.com"
  chicago: "team@rentscene.com"
  boston: "team@rentscene.com"
  "los-angeles": "team@rentscene.com"
  philadelphia: "team@rentscene.com"
  stamford: "team@rentscene.com"
  "washington-dc": "team@rentscene.com"
  "": "team@rentscene.com"
  test: "rentscenetest@gmail.com"

CheckAvailabilityRequests.after.insert (userId, request) ->
  # Sometimes the cityId isn't getting passed, throwing an error... so hard-coding Philadelphia as a temporary stop-gap.
  request.cityId = "Philadelphia"  unless request.cityId is not "no city id found"
  request.cityName = "Philadelphia"  unless request.cityId is not "no city name found"

  transformedRequest = share.Transformations.CheckAvailabilityRequest(request)

  Email.send
    from: "bender-checkavail@rentscene.com"
    to: emails[transformedRequest.cityId]
    replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
    subject: "Check Availability Request from " + transformedRequest.name + " in " + transformedRequest.cityName
    html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/checkAvailabilityEmail.html"))


ContactUsRequests.after.insert (userId, request) ->
  transformedRequest = share.Transformations.ContactUsRequest(request)
  Email.send
    from: "bender-contactus@rentscene.com"
    to: emails[transformedRequest.cityId]
    replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
    subject: 'Contact Us Message from ' + transformedRequest.name + ' in ' + transformedRequest.cityName
    html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))