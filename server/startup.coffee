Meteor.startup ->
  if Meteor.settings.public.isDebug
    share.loadFixtures()
#    Meteor.setInterval(share.loadFixtures, 300)
