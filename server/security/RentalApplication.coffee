RentalApplications.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier, options) ->
    true
  remove: (userId, doc) ->
    Security.canOperateWithBuilding()