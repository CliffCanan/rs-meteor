@currentUserHandle = Meteor.subscribe("currentUser")
#@CheckAvailabilityRequestsHandle = Meteor.subscribe("CheckAvailabilityRequests")
#@ContactUsRequestsHandle = Meteor.subscribe("ContactUsRequests")

@subscribeToBuildingImages = (template, buildingId) -> template.subscribe "buildingImages", buildingId
