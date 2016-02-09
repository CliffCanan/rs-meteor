Template.faq.onRendered ->


Template.faq.helpers

Template.building.events
  "click .faq-page-wrap a": (event, template) ->
    elemId = $(event.currentTarget).attr('id')

    if elemId
      analytics.track "Clicked FAQ Link (Building)", {label: elemId} unless Meteor.user()
