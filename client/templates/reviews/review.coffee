Template.review.helpers
  building: ->
    Buildings.findOne(@buildingId)
  formatedCreatedAt: ->
    moment(@createdAt).format('MM/DD/YYYY')
  isPublished: ->
    @isPublished
  showBuildingLink: ->
    Security.canOperateWithBuilding() and not @isPublished

Template.review.events
  "click .publish-review": (event, template) ->
    Meteor.call 'publishReview', @_id

  "click .edit-review": (event, template) ->

  "click .hide-review": (event, template) ->
    Meteor.call 'hideReview', @_id

  "click .remove-review": (event, template) ->
    if confirm 'Are you sure you want to remove this review? It will be archived.'
      Meteor.call 'removeReview', @_id

  "click .edit-review": (event, template) ->
    defaults = @
    Session.set('reviewFormDefaults', defaults)