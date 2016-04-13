Template.footer.helpers
  shouldHideFooter: ->
    Session.get("shouldHideFooter") or Session.get("viewType") is "quickView"

Template.footer.rendered = ->

Template.footer.events
  "click .page-footer a": (event, template) ->
    element = $(event.currentTarget).attr("id")
    analytics.track "Clicked " + element + " (Footer)" unless Meteor.user()
    true
