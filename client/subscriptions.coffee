@currentUserHandle = Meteor.subscribe("currentUser")
@allUsers = Meteor.subscribe("allUsers")
@CheckAvailabilityRequestsHandle = Meteor.subscribe("CheckAvailabilityRequests")
@ContactUsRequestsHandle = Meteor.subscribe("ContactUsRequests")
@UserListsHandle = Meteor.subscribe("UserLists")
@propertyLists = Meteor.subscribe("propertyLists")
@ClientRecommendationsHandle = Meteor.subscribe("ClientRecommendations");