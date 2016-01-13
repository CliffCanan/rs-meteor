Template.cityQuickView.onCreated ->
  params = Router.current().params
  @autorun =>
    @subscribe "buildingsQuickView", params.cityId, params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1

updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityQuickView.onRendered ->
  updateScroll()

  instance = Template.instance()

  @autorun =>
    Tracker.afterFlush ->
      $('#quick-view-table').on 'click', '.toggle-units', ->
        $(@).closest('tr').nextUntil('tr.tablesorter-hasChildRow').find('td').toggle()

        $i = $(@).find('i')

        if $i.hasClass('fa-plus-square-o')
          $i.removeClass('fa-plus-square-o')
          $i.addClass('fa-minus-square-o')
        else
          $i.removeClass('fa-minus-square-o')
          $i.addClass('fa-plus-square-o')

Template.cityQuickView.helpers
  buildingsProcessed: ->
    buildingIds = _.unique(_.map(Buildings.find({parentId: {$exists: true}}).fetch(), (building) -> 
      building.parentId
    ))

    parents = Buildings.find({_id: {$in: buildingIds}}).fetch()

    _.each parents, (parent) ->
      children = Buildings.find({parentId: parent._id}).fetch()
      parent.children = children
      parent.isParent = true

    parents

  buildingsReady: ->
    Template.instance().buildingsReady.get()
  
# Separate events for recommend toggle
Template.cityQuickView.events
  "click .recommend-toggle": (event, template) ->
    clientId = Router.current().data().clientId
    buildingId = @._id
    buildingIds = Router.current().data().buildingIds || []

    if @._id in buildingIds
      Meteor.call "unrecommendBuilding", clientId, buildingId
    else
      Meteor.call "recommendBuilding", clientId, buildingId

