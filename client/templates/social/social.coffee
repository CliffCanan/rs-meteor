Template.social.helpers
  helper: ->
#    inspect later
    try
      addthis.layers.refresh()
    catch error
    return ""

Template.social.rendered = ->
  if addthis
    addthis.init()

Template.social.events
#  "click .selector": (event, template) ->


