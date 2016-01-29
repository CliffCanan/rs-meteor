Template.footer.helpers
  showIDXDisclaimer: ->
    Router.current().route.getName() is 'city' or Router.current().route.getName() is 'building'

Template.footer.rendered = ->

Template.footer.events
#  "click .selector": (event, template) ->
