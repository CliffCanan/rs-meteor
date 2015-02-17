Template.messageSent.helpers
#  helper: ->

Template.messageSent.rendered = ->

Template.messageSent.events
  "click .continue-browsing": grab encapsulate (event, template) ->
    $('#messageSentPopup').modal('hide')
