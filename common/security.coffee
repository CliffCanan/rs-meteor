@Security =
  canOperateWithBuilding: (user) ->
    user = if user? then user else Meteor.user()
    user?.role in ["super", "admin", "staff"]
