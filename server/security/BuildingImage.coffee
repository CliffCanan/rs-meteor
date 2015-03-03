BuildingImages.allow
  insert: (userId, file) ->
#    if userId
#      return Meteor.user().role is "super" or Meteor.user().role is "admin"
#    else
#      return false
    true
  update: (userId, file, fields, modifier, options) ->
    if userId
      return Meteor.user().role is "super" or Meteor.user().role is "admin"
    else
      return false
  remove: (userId, file) ->
    if userId
      return Meteor.user().role is "super" or Meteor.user().role is "admin"
    else
      return false
  download: (userId, file) ->
    true
