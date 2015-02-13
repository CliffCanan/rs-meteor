$document = $(document)

$document.on "click", ".logout", encapsulate (event) ->
  Meteor.logout ->
    mixpanel.cookie.clear()
    location.href = location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + "/"

$document.on "click", ".reconnect", grab encapsulate (event) ->
  Meteor.reconnect()
