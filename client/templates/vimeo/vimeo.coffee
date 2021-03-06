Template.vimeo.onCreated ->
  @subscribe("vimeoVideos")

Template.vimeo.onRendered ->
  Meteor.call 'getVimeoVideos'
  Meteor.typeahead.inject()

  # Set a default video once the Vimeo subscription is completed.
  Tracker.autorun (c) ->
    if video = VimeoVideos.findOne()
      Session.set "currentVideo", video
      c.stop()

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

    # We have to use $each to specify the $position operator to add this video on top of the list
    Buildings.update({_id: template.data._id}, {$push: {images: {$each: [currentVideo], $position: 0}}})
    $('#vimeo-popup').modal('hide')

  "click #import-videos": (event, template) ->
      Meteor.call 'getVimeoVideos'