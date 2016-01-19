Template.cityQuickView.onCreated ->
  self = @
  @tablesorterReady = new ReactiveVar()
  @buildingsReady = new ReactiveVar()

  $("<link/>", {
     rel: "stylesheet",
     type: "text/css",
     href: "https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/css/theme.bootstrap.min.css"
  }).appendTo("head");

  $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.min.js', ->
    $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.widgets.min.js', ->
      self.tablesorterReady.set(true)

  @autorun =>
    data = Router.current().data()
    params = Router.current().params

    if data.neighborhoodSlug
      params.query.neighborhoodSlug = data.neighborhoodSlug
    handle = quickViewSubs.subscribe "buildingsQuickView", params.cityId, params.query, if Meteor.isClient then Session.get("cityPageData")?.page or 1 else 1
    @buildingsReady.set handle.ready()

updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityQuickView.onRendered ->
  # We have to force the quick view table to redraw or it won't show up.
  $('.main-city-list-wrap').css('height', '100%')
  
  instance = @

  @autorun =>
    if Template.instance().buildingsReady.get() and Template.instance().tablesorterReady.get()
      Tracker.afterFlush ->
        $table = $('#quick-view-table').tablesorter
          theme: "bootstrap"
          widthFixed: true
          headerTemplate : '{content} {icon}'
          widgets: ["uitheme", "filter"]
          widgetOptions:
            filter_columnFilters: false
            filter_reset: '.reset'
            filter_childRows: true
            filter_childByColumn: true
            filter_childWithSibs: false

        $.tablesorter.filter.bindSearch $table, $('.filter')

        $('#quick-view-table').removeClass('table-striped')
        
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

