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
      }
    , callback = (error, id) ->
        cl error
        cl id
        unless error
          return id
    )
  else
    userId = user._id

  userList =  UserLists.findOne({customerId: userId})
  if not userList
    userListId = UserLists.insert({
        customerId: userId
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
    ContactUsRequest.agentName = userListAgent.name
  else
    ContactUsRequest.agentName = ""

  cl "ContactUsRequest", ContactUsRequest
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
      from: transformedRequest.name + ' <' + transformedRequest.email + '>'
      to: 'rentscenetest+' + transformedRequest.city + '@gmail.com'
      replyTo: transformedRequest.email
      subject: 'New contact us message from ' + transformedRequest.name + ' in ' + transformedRequest.city
      html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))

