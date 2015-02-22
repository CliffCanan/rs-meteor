Meteor.startup ->
  userId = Meteor.userId()
  if Meteor.settings.public.isDebug
    if (!userId && (location.host == "localhost:3000" || location.host.indexOf("192.168") != -1) && document.cookie.indexOf("autologin=false") == -1)
      if jQuery.browser.mozilla
        Meteor.loginWithToken("Moderator")
      else
        Meteor.loginWithToken("Admin")

share.autologinDetected = false
share.isAutologin = ->
  share.autologinDetected or location.href.indexOf("/autologin") isnt -1
