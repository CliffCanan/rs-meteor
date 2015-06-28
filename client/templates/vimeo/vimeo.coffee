Template.vimeo.onRendered ->
  $('#thumbnail-slider .item:first').addClass('active');
  $('#thumbnail-slider').carousel({
    interval: 0
  });

Template.vimeo.helpers
  "videos": ->
    videos = VimeoVideos.find().fetch()
    n = 6;
    lists = _.groupBy videos, (element, index) ->
      Math.floor index/n
    lists = _.toArray lists
  "currentVideo": ->
    Session.get "currentVideo"

Template.vimeo.events
  "click #import-videos": (event, template) ->
      Meteor.call 'getVimeoVideos', (err, result) ->
        Session.set 'vimeoVideos', result
  "click .video-thumbnail": (event, template) ->
      Session.set "currentVideo", this