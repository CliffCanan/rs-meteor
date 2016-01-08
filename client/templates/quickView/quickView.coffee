Template.quickView.onCreated ->
  @tablesorterReady = new ReactiveVar()
  @buildingsReady = new ReactiveVar()
  # @autorun =>
  #   handle = @subscribe 'allBuildings'
  #   @buildingsReady.set handle.ready()
  self = @

  $("<link/>", {
     rel: "stylesheet",
     type: "text/css",
     href: "https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/css/theme.bootstrap.min.css"
  }).appendTo("head");

  $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.min.js', ->
    # $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/widgets/widget-filter.min.js', ->
    $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.widgets.min.js', ->
      self.tablesorterReady.set(true)

Template.quickView.onRendered ->
  instance = @

  @autorun =>
    if Template.instance().tablesorterReady.get()
      Tracker.afterFlush ->
        $table = $('#quick-view-table').tablesorter
          theme: "bootstrap"
          widgets: ["filter"]
          widgetOptions:
            filter_columnFilters: false
            filter_reset: '.reset'

        $.tablesorter.filter.bindSearch $table, $('.select-city')
        $('#quick-view-table').on('click', '.toggle-units', ->
          $(@).closest('tr').nextUntil('tr.tablesorter-hasChildRow').find('td').toggle()
        )


Template.quickView.helpers
  buildings: ->
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
    true
  #   Template.instance().buildingsReady.get()

  options: ->
    columns: [
      {data: 'title', title: 'Building'}
      {data: 'units', title: 'Units', tmpl: Template.quickViewUnits}
      {data: 'beds', title: 'Beds', render: (value, type, object) -> 
         if object.bedroomsFrom then "#{object.bedroomsFrom} - #{object.bedroomsTo}" else '-'
      }
      {data: 'bathrooms', title: 'Bathrooms', render: (value, type, object) -> 
         if object.bathroomsFrom then "#{object.bathroomsFrom} - #{object.bathroomsTo}" else '-'
      }
      {data: 'sqft', title: 'Square Ft', render: (value, type, object) -> 
         if object.sqftFrom then "#{object.sqftFrom} - #{object.sqftTo}" else '-'
      }
      {data: 'buildingEntry', title: 'Building entry'}
      {data: 'laundry', title: 'Laundry'}
      {data: 'availableAt', title: 'Date available', render: (value, type, object) -> if value then moment(value).format('D MMM YYYY') else '-'}
      {data: 'price', title: 'Price', render: (value, type, object) -> 
         if object.agroPriceTotalFrom then "#{object.agroPriceTotalFrom} - #{object.agroPriceTotalTo}" else '-'
      }
    ]

    
Template.quickViewBuilding.helpers
  unitCount: ->
    if @children then @children.length else '-'
