share.Transformations = {}

share.transform = (cls, object) ->
  if object instanceof cls or not object then object else new cls(object)
