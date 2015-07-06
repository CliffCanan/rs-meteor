Template.vimeo.onRendered ->
  Meteor.call 'getVimeoVideos'
  Meteor.typeahead.inject()
  Session.set "currentVideo", VimeoVideos.findOne()

Template.vimeo.helpers
  videosSearch: (query, sync, async) ->
    suggestions = VimeoVideos.find(name: {$regex: new RegExp query, "i"})
    if suggestions.count()
      sync(suggestions.fetch().map((video)->
        duration = video.duration
        minutes = Math.floor(duration / 60);
        seconds = duration - minutes * 60
        seconds = "0#{seconds}" if seconds < 10

        id: video._id
        vimeoId: video.vimeoId
        uploadedAt: moment(video.uploadedAt).format('Do MMM YYYY')
        value: video.name
        thumbnail: video.thumbnail
        duration: "#{minutes}:#{seconds}"
      ))
      return
  selectedVideo: (event, suggestion, datasetName) ->
    $('#current-video iframe').attr('src', '');
    video = VimeoVideos.findOne(suggestion.id);
    Session.set "currentVideo", video
  currentVideo: ->
    Session.get "currentVideo"

Template.vimeo.events
  "click #confirm-video": (event, template) ->
    currentVideo = Session.get "currentVideo"
    Buildings.update({_id: template.data._id}, {$addToSet: {images: currentVideo}})
    $('#vimeo-popup').hide()
  "click #import-videos": (event, template) ->
      Meteor.call 'getVimeoVideos'