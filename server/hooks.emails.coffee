emails =
  atlanta: "team@rentscene.com"
  chicago: "team@rentscene.com"
  boston: "team@rentscene.com"
  "los-angeles": "team@rentscene.com"
  philadelphia: "team@rentscene.com"
  "Philadelphia": "team@rentscene.com"
  stamford: "team@rentscene.com"
  "washington-dc": "team@rentscene.com"
  "": "team@rentscene.com"
  test: "rentscenetest@gmail.com"

CheckAvailabilityRequests.after.insert (userId, request) ->
  # Sometimes the cityId isn't getting passed, throwing an error... so hard-coding Philadelphia as a temporary stop-gap.
  #request.cityId = "Philadelphia"  if !request.cityId || request.cityId is "no city id found"
  request.cityName = "Philadelphia"  if !request.cityName || request.cityName is "no city name found"

  transformedRequest = share.Transformations.CheckAvailabilityRequest(request)

  #firstName = transformedRequest.name.split(" ")[0].toLowerCase()
  #firstName = firstName.charAt(0).toUpperCase() + firstName.slice(1)

  Email.send
    from: "bender-checkavail@rentscene.com"
    to: emails[transformedRequest.cityId]
    replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
    subject: 'Apartment Inquiry on Rent Scene - Your perfect rental is waiting ' +  transformedRequest.name
    html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/checkAvailabilityEmail.html"))


ContactUsRequests.after.insert (userId, request) ->
  # Sometimes the cityId isn't getting passed, throwing an error... so hard-coding Philadelphia as a temporary stop-gap.
  request.cityId = "Philadelphia"  if !request.cityId || request.cityId is "no city id found"
  request.cityName = "Philadelphia"  if !request.cityName || request.cityName is "no city name found"

  transformedRequest = share.Transformations.ContactUsRequest(request)

  firstName = transformedRequest.name.split(" ")[0].toLowerCase()
  firstName = firstName.charAt(0).toUpperCase() + firstName.slice(1)
  cityNickname = if request.cityName is "Philadelphia" then "Philly" else request.cityName

  Email.send
    from: "bender-contactus@rentscene.com"
    to: emails[transformedRequest.cityId]
    replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
    subject: firstName + ', Let\'s find your perfect ' + cityNickname + ' apartment!'
    html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))