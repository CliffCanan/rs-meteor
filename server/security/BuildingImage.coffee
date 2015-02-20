BuildingImages.allow
  insert: (userId, file) ->
    false
  update: (userId, file, fields, modifier, options) ->
    false
  remove: (userId, file) ->
    false
  download: (userId, file) ->
    true
