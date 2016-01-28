emails =
  atlanta: "atlanta@rentscene.com"
  chicago: "chicago@rentscene.com"
  boston: "team@rentscene.com"
  "los-angeles": "team@rentscene.com"
  philadelphia: "team@rentscene.com"
  stamford: "team@rentscene.com"
  "washington-dc": "team@rentscene.com"
  "": "team@rentscene.com"
  test: "rentscenetest@gmail.com"

CheckAvailabilityRequests.after.insert (userId, request) ->
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