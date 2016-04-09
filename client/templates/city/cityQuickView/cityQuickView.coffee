Template.cityQuickView.onCreated ->
  self = @
  @tablesorterReady = new ReactiveVar()
  @buildingsReady = new ReactiveVar()
  @initialRecommendBuildingId = new ReactiveVar()

  $("<link/>", {
     rel: "stylesheet",
     type: "text/css",
     href: "https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/css/theme.bootstrap.min.css"
  }).appendTo("head");

  $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.min.js', ->
    $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.widgets.min.js', ->
      self.tablesorterReady.set(true)


updateScroll = ->
  if citySubs.ready
    _.defer ->
      $(".main-city-list-wrap").scrollTop(Session.get("cityScroll"))
  else
    Meteor.setTimeout(updateScroll, 100)

Template.cityQuickView.onRendered ->
  $('[data-toggle="tooltip"]').tooltip()

  # We have to force the quick view table to redraw or it won't show up.
  $('.main-city-list-wrap').css('height', '100%')

  instance = @

  @autorun =>
    if Template.instance().tablesorterReady.get()
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
          $(@).closest('tr').nextUntil('tr:not(.tablesorter-childRow)').find('td').toggle()

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

  rowClass: ->
    if @hasChildren
      'tablesorter-hasChildRow info'
    else
      'warning'
  
# Separate events for recommend toggle
Template.cityQuickView.events
  'click a.recommend-toggle': (event, template) ->
    if clientObject = Session.get('recommendationsClientObject')
      $target = $(event.target).parent()
      if $target.data('isrecommended') is false
        Meteor.call "recommendBuilding", clientObject._id, @_id
        $target.data('isrecommended', true)
      else if $target.data('isrecommended') is true
        Meteor.call "unrecommendBuilding", clientObject._id, @_id
        $target.data('isrecommended', false)
    else
      template.initialRecommendBuildingId.set @_id
      $('#quick-view-recommend-popup').modal('toggle')

  'click #start-recommending': (event, template) ->
    $('#quick-view-recommend-popup').modal('toggle')
    clientObject = ClientRecommendations.findOne(Session.get('clientId'))
    console.log "Session ID is %s, initial Id is %s", Session.get('clientId'), template.initialRecommendBuildingId.get()
    Meteor.call "recommendBuilding", Session.get('clientId'), template.initialRecommendBuildingId.get()
    Session.set('recommendationsClientObject', clientObject)
