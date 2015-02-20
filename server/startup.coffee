Meteor.startup ->
  share.loadFixtures()

#  if Meteor.settings.public.isDebug
#    Meteor.setInterval(share.loadFixtures, 300)
