@Security =
  canOperateWithBuilding: (userId) ->
    if userId isnt undefined
      user = Meteor.users.findOne(userId)
    else
      user = Meteor.user()
    user?.role in ["super", "admin", "staff"]
