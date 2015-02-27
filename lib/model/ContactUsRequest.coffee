class ContactUsRequest
  constructor: (doc) ->
    _.extend(@, doc)

share.Transformations.ContactUsRequest = _.partial(share.transform, ContactUsRequest)

@ContactUsRequests = new Mongo.Collection("ContactUsRequests",
  transform: if Meteor.isClient then share.Transformations.ContactUsRequest else null
)

@ContactUsRequestPreSave = (changes) ->
  now = new Date()
  changes.updatedAt = changes.updatedAt or now

ContactUsRequests.before.insert (userId, ContactUsRequest) ->



  user = Meteor.users.findOne({email: ContactUsRequest.email})
  cl "user", user

  if not user
    userId = Meteor.users.insert({
        name: ContactUsRequest.name
        email: ContactUsRequest.email
        role: "customer"
        autoSaved: true
      }
    , callback = (error, id) ->
        unless error
          return id
    )
  else
    userId = user._id

  userList =  UserLists.findOne({customerId: userId})

  if not userList
    userListId = UserLists.insert({
        customerId: userId
        customerName: ContactUsRequest.name
        cityId: ContactUsRequest.city
        buildingsIds: []
      }
    , callback = (error, id) ->
        unless error
          return id
    )
  else
    userListId = userList._id
    userListAgent = Meteor.users.findOne({_id: userList.agentId})

  ContactUsRequest.userListId = userListId
  if userListAgent
    ContactUsRequest.agentName = userListAgent.profile.name
    ContactUsRequest.agentId = userListAgent._id
  else
    ContactUsRequest.agentName = ""
    ContactUsRequest.agentId = ""

  if not ContactUsRequest.city
    ContactUsRequest.city = ""
  if not ContactUsRequest.cityId
    ContactUsRequest.cityId = ""
  ContactUsRequest._id ||= Random.id()
  now = new Date()
  _.defaults(ContactUsRequest,
    updatedAt: now
    createdAt: now
  )
  ContactUsRequestPreSave.call(@, ContactUsRequest)
  true

ContactUsRequests.before.update (userId, ContactUsRequest, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set or {}
  ContactUsRequestPreSave.call(@, modifier.$set)
  true

ContactUsRequests.after.insert (userId, request) ->
  if Meteor.isServer
    transformedRequest = share.Transformations.ContactUsRequest(request)
    Email.send
      from: "bender@rentscene.com"
      to: 'rentscenetest+' + transformedRequest.cityId + '@gmail.com'
      replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
      subject: 'New contact us message from ' + transformedRequest.name + ' in ' + transformedRequest.cityName
      html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))

