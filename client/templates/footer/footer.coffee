Template.footer.helpers
  shouldHideFooter: ->
    # Cliff (7/8/16): this is hiding the footer on other pages once the 'viewType' is set to 'quickView'
    #                 so need to add an additional check here to make sure it is ONLY hidden on the /City page
    Session.get("shouldHideFooter") or Session.get("viewType") is "quickView"

Template.footer.rendered = ->

Template.footer.events
  "click .page-footer a": (event, template) ->
    element = $(event.currentTarget).attr("id")
    analytics.track "Clicked " + element + " (Footer)" unless Meteor.user()
    true
