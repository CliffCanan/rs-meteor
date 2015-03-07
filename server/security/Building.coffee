Buildings.allow
  insert: (userId, file) ->
    Security.canOperateWithBuilding()
  update: (userId, file, fields, modifier, options) ->
    Security.canOperateWithBuilding()
  remove: (userId, file) ->
    Security.canOperateWithBuilding()
