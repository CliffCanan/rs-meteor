Template.propertylist.helpers
  buildings: ->
    buildingsFound = []
    console.log("buildings found: ", Buildings.find({_id: {$in: @propertyList.buildings}}, {sort: {createdAt: -1, _id: 1}}).fetch())
    if @propertyList
      if @propertyList.buildings
        buildingsFound = Buildings.find({_id: {$in: @propertyList.buildings}}, {sort: {createdAt: -1, _id: 1}})
    buildingsFound

Template.propertylist.rendered = ->