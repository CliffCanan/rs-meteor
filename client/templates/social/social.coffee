Template.social.created = ->
  addthis.init()

Template.social.helpers
  helper: ->
    addthis.layers.refresh()
    return ""

Template.social.rendered = ->
  addthis.init()

Template.social.events
#  "click .selector": (event, template) ->


