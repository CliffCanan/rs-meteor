Template.propertylist.helpers
  buildings: ->
    buildingsFound = []
    if @propertyList
      if @propertyList.buildings
        buildingsFound = Buildings.find({_id: {$in: @propertyList.buildings}}, {sort: {createdAt: -1, _id: 1}})
    buildingsFound
  listName: ->
  	@propertyList.name

Template.propertylist.created = ->

Template.propertylist.rendered = ->

Template.propertylist.events
