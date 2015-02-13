Mixpanel = Meteor.npmRequire("mixpanel")
@mixpanel = Mixpanel.init(Meteor.settings.public.mixpanel.token)
if Meteor.settings.public.mixpanel.disabled
  mixpanel.send_request = -> # don't really send any requests
else
  mixpanel.set_config({debug: Meteor.settings.public.isDebug})
