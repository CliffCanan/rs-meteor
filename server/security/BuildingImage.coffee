BuildingImages.allow
  insert: (userId, file) ->
#    Error: "Queue" failed [503] Error in method "/cfs/files/:value/:value/", Error: Error: Meteor.userId can only be invoked in method calls. Use this.userId in publish functions.
#    Security.canOperateWithBuilding()
    true
  update: (userId, file, fields, modifier, options) ->
    Security.canOperateWithBuilding()
  remove: (userId, file) ->
    Security.canOperateWithBuilding()
  download: (userId, file) ->
    true
