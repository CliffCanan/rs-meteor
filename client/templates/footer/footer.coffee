Template.footer.helpers
#  helper: ->

Template.footer.rendered = ->

Template.footer.events
  "click .page-footer a": grab encapsulate (event, template) ->
    element = $(event.target).attr("id")
    console.log("[" + element + "] clicked")
    analytics.track "Clicked " + element + " (Footer)" unless Meteor.user()
    true