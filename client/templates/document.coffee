$document = $(document)

$document.on "click", ".logout", encapsulate (event) ->
  Meteor.logout ->
    mixpanel.cookie.clear()
    location.href = location.protocol + "//" + location.hostname + (if location.port then ':' + location.port else '') + "/"

$document.on "click", ".reconnect", grab encapsulate (event) ->
  Meteor.reconnect()

$document.on "click", (e) ->
  $(".dropdown.open").each ->
    $dd = $(@)
    if not $dd.is(e.target) and $dd.has(e.target).length is 0
      $dd.removeClass("open")
