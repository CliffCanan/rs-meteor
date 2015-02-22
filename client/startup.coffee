process.env.MAIL_URL = 'smtp://postmaster@sandbox23e08b6535214d63a9b1f2e8543cbc7e.mailgun.org:f53e81147a90425a9fbd73a9023d559b@smtp.mailgun.org:587';
Kadira.connect('SdodTDamkAJBguSo2', '69be490e-3389-4908-be4d-588a3831d267')

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
