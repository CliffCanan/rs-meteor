Template.vimeo.onRendered ->
  Meteor.typeahead.inject()
  $('#thumbnail-slider .item:first').addClass('active');
  $('#thumbnail-slider').carousel({
    interval: 0
  });
  Session.set "currentVideo", VimeoVideos.findOne()

Template.vimeo.helpers
  videos: ->
    videos = VimeoVideos.find().fetch()
    n = 6;
    lists = _.groupBy videos, (element, index) ->
      Math.floor index/n
    lists = _.toArray lists
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
  "click #import-videos": (event, template) ->
      Meteor.call 'getVimeoVideos'
  "click .video-thumbnail": (event, template) ->
      Session.set "currentVideo", this