Template.quickView.onCreated ->
  @tablesorterReady = new ReactiveVar()
  @buildingsReady = new ReactiveVar()
  @autorun =>
    handle = @subscribe 'allBuildingsQuickView'
    @buildingsReady.set handle.ready()
  self = @

  $("<link/>", {
     rel: "stylesheet",
     type: "text/css",
     href: "https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/css/theme.bootstrap.min.css"
  }).appendTo("head");

  $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.min.js', ->
    $.getScript 'https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.25.0/js/jquery.tablesorter.widgets.min.js', ->
      self.tablesorterReady.set(true)

Template.quickView.onRendered ->
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
    Template.instance().buildingsReady.get()

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
  bedrooms: ->
    value = @bedroomsFrom
    unless @bedroomsFrom is @bedroomsTo
      value += " - " + @bedroomsTo
    value
  bathrooms: ->
    value = @bathroomsFrom
    unless @bathroomsFrom is @bathroomsTo
      value += " - " + @bathroomsTo
    value
  securityValue: ->
    switch @security
      when 0 then "Unknown"
      when 1 then "Doorman"
      when 2 then "No Doorman"
  laundryValue: ->
    switch @laundry
      when 0 then "Unknown"
      when 1 then "In-unit Laundry"
      when 2 then "Shared Laundry"
      when 3 then "No Laundry"
  unitCount: ->
    if @children then @children.length else '-'
  availableAtFormatted: ->
    if @availableAt then @availableAt.getMonth() + "/" + @availableAt.getDate() + "/" +@availableAt.getFullYear() else '-'
