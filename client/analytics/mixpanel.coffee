Meteor.startup ->
  mixpanel.init(Meteor.settings.public.mixpanel.token, {api_host: "https://api.mixpanel.com"})
  if Meteor.settings.public.mixpanel.disabled
    mixpanel.disable()
  else
    mixpanel.set_config({debug: Meteor.settings.public.isDebug})
#  unless Meteor.userId()
#    mixpanel.track("Visit")
