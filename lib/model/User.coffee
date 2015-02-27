class User
  constructor: (doc) ->
    _.extend(@, doc)
    @email = @emails?[0]?.address
    @name = @profile.name.replace(/\d/g, "")
    @firstName = @name.split(' ').slice(0, 1).join(' ')
    @lastName = @name.split(' ').slice(1).join(' ')

share.Transformations.user = _.partial(share.transform, User)

#@Users = new Mongo.Collection("users",
#  transform: if Meteor.isClient then share.Transformations.User else null
#)
#
#@UserPreSave = (changes) ->
#  now = new Date()
#  changes.updatedAt = changes.updatedAt or now
#
#Users.before.insert (userId, User) ->
#  User._id ||= Random.id()
#  now = new Date()
#  _.defaults(User,
#    updatedAt: now
#    createdAt: now
#  )
#  UserPreSave.call(@, User)
#  true
#
#Users.before.update (userId, User, fieldNames, modifier, options) ->
#  modifier.$set = modifier.$set or {}
#  UserPreSave.call(@, modifier.$set)
#  true

#Users.after.insert (userId, request) ->
#  if Meteor.isServer
#    transformedRequest = share.Transformations.User(request)
#    Email.send
#      from: "bender@rentscene.com"
#      to: 'rentscenetest+' + transformedRequest.city + '@gmail.com'
#      replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
#      subject: 'New contact us message from ' + transformedRequest.name + ' in ' + transformedRequest.cityName
#      html: Spacebars.toHTML({request: transformedRequest, settings: Meteor.settings}, Assets.getText("requests/contactUsEmail.html"))


