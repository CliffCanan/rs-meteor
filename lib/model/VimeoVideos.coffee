class VimeoVideo
  constructor: (doc) ->
    _.extend(@, doc)
  findUnitByParent: (parentId) ->
    _.find @.unitIds, (item) ->
      item.parentId is parentId

share.Transformations.VimeoVideo = _.partial(share.transform, VimeoVideo)

@VimeoVideos = new Mongo.Collection "vimeo_videos",
  transform: if Meteor.isClient then share.Transformations.VimeoVideo else null