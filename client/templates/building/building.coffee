Template.building.helpers
  admin: ->
    Meteor.user().role is "admin"
  isFurnished: ->
    if @furnished
      return @furnished is "Y"

  getBuildingData: ->
    cityId: @cityId
    neighborhoodSlug: @neighborhoodSlug
    buildingSlug: @slug

  hasParent: ->
    return @parentId and @parentId isnt '' and @parentId isnt '0'
  parentNeighborhoodSlug: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.neighborhoodSlug
  parentSlug: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.slug
  parentName: ->
    parent = Buildings.findOne({_id: @parentId})
    return parent.name

  ironRouterHack: ->
    Router.current() # reactivity
    $('[data-toggle="tooltip"]').tooltip()
    addthis?.init()
    $carousel = $(".carousel")
    carousel = $carousel.data("bs.carousel")
    if carousel
      carousel.pause()
      carousel.destroy()
    $firstItem = $carousel.find(".item:first")
    if $firstItem.length
      $firstItem.addClass("active")
      $carousel.show().carousel()
    else
      $carousel.hide()
    return ""
  showAllBuildingUnits: ->
    Session.get("showAllBuildingUnits")
  buildingUnitsArray: ->
    array = []
    i = 0
    for unit in @buildingUnits().fetch()
      array.push(
        {
          index: i++
          unit: [unit]
        }
      )
    array
Template.building.rendered = ->
  Session.set("showAllBuildingUnits", false)

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    $('#checkAvailabilityPopup').modal('show')

  "click .unit-check-availability": grab encapsulate (event, template) ->
    Session.set("currentUnit", @)
    $('#checkAvailabilityPopup').modal('show')

  "click .building-unit-item-more": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", true)

  "click .building-unit-item-less": grab encapsulate (event, template) ->
    Session.set("showAllBuildingUnits", false)

  "click .remove-image": grab encapsulate (event, template) ->
    Buildings.update({ _id: template.data.building._id}, { $pull: { images: {"EJSON$value.EJSON_id": @_id}} })

  "change .choose-image-input": grab encapsulate (event, template) ->
    cl @
    cl @_id
    buildingId = @_id
    FS.Utility.eachFile(event, (file) ->
      cl "file", file
      inserted = BuildingImages.insert(file)
      cl inserted
      newObject = {}
      newObject.EJSON$type = "FS.File"
      newObject.EJSON$value = {}
      newObject.EJSON$value.EJSON_id = inserted._id
      newObject.EJSON$value.EJSONcollectionName = "images"
      Buildings.update({_id: buildingId}, {$addToSet: {images: newObject}}, (error, effectedRows) ->
        cl "effected", effectedRows
      )
    )
#    cl "files", event.target.files
#    files = event.target.files
#    for file in files
##      try
#        fsFile = new FS.File(file)
#        fsFile.metadata = {owner: Meteor.userId()}
#        currentFile = BuildingImages.insert(fsFile, (err, fileObj) ->
#          cl "fileObj", fileObj
#          cl "err", err
#        )
#        cl "currentFile", currentFile
#        Buildings.update(_id: @_id, {$addToSet: {images: currentFile}})
##      catch error
##        cl "Oops", error
