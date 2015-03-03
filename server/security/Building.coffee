Buildings.allow
  insert: (userId, file) ->
    false
  update: (userId, file, fields, modifier, options) ->
    if userId
      cl Meteor.user().role is "super" or Meteor.user().role is "admin"
      return Meteor.user().role is "super" or Meteor.user().role is "admin"
    else
      return false
  remove: (userId, file) ->
    false
