Template.footer.helpers
#  helper: ->

Template.footer.rendered = ->

Template.footer.events
  "click .page-footer a": (event, template) ->
    element = $(event.currentTarget).attr("id")
    console.log("[" + element + "] clicked")
    analytics.track "Clicked " + element + " (Footer)" unless Meteor.user()

    #href = $(event.currentTarget).attr("href")
    #window.open('http://www.smkproduction.eu5.org','_blank') if href and href != '/'

    true