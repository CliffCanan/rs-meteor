hasPrivilege = (userId) ->
    if userId isnt undefined
      user = Meteor.users.findOne(userId)
    else
      user = Meteor.user()
    user?.role in ["super", "admin", "staff"]

@Security =
  canOperateWithBuilding: (userId) ->
    hasPrivilege userId
  canManageClients: (userId) ->
    hasPrivilege userId