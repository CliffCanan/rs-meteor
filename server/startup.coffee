process.env.MAIL_URL = 'smtp://postmaster@sandbox23e08b6535214d63a9b1f2e8543cbc7e.mailgun.org:f53e81147a90425a9fbd73a9023d559b@smtp.mailgun.org:587'

Meteor.startup ->
  share.loadFixtures()

#  if Meteor.settings.public.isDebug
#    Meteor.setInterval(share.loadFixtures, 300)
