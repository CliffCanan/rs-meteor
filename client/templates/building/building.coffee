Template.building.helpers
  helper: ->
    return ""
  hasPetsInfo: ->
    pets.value isnt "3" or 3
  pets: ->
    pet = {}
    pet.allowed = petsAllowance[@pets.value]
    
    pet.comment

Template.building.rendered = ->
  addthis.init()

Template.building.events
  "click .check-availability": grab encapsulate (event, template) ->
    $('#checkAvailabilityPopup').modal('show')

petsAllowance =
  "0":
    value: "Pets Allowed"
  "1":
    value: "Pets Allowed"
  "2":
    value: "Pets not allowed"
  "3":
    value: "No info on pets"
