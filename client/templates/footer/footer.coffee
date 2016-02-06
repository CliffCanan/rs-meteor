Template.footer.helpers
#  helper: ->

Template.footer.rendered = ->

Template.footer.events
  "click .page-footer a": (event, template) ->
    element = $(event.currentTarget).attr("id")
    analytics.track "Clicked " + element + " (Footer)" unless Meteor.user()
    true