Meteor.startup ->
  Tracker.autorun ->
    user = Meteor.user()
    if not user
      return
    $(window).scrollTop(0) # cause, you know, that's the most logical thing to do after logging the user in
