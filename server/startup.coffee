process.env.MAIL_URL = 'smtp://postmaster@sandbox23e08b6535214d63a9b1f2e8543cbc7e.mailgun.org:f53e81147a90425a9fbd73a9023d559b@smtp.mailgun.org:587'

Meteor.startup ->
  Buildings._ensureIndex({slug: 1}, {unique: true, background: true})

  if Meteor.settings.public.isDebug
    share.loadFixtures()
#    Meteor.setInterval(share.loadFixtures, 300)
#    mysqlImport()
  else
    mysqlImport(true)

#  if Meteor.settings.public.isDebug
#    Meteor.setInterval(share.loadFixtures, 300)
