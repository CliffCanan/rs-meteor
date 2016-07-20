# Cast "2018-32 Walnut St 15K" to "2018 Walnut St 15K"
formatTitle = (title) ->
  title.replace /^(\d+)-\w+/, "$1"

Buildings.before.insert (userId, building) ->
  building.title = formatTitle building.title
  true

Buildings.before.update (userId, building, fieldNames, modifier, options) ->
  title = modifier?.$set?.title
  modifier.$set.title = formatTitle title if title

  true
