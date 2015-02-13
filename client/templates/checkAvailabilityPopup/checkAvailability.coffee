Template.checkAvailability.helpers
#  helper: ->

Template.checkAvailability.rendered = ->
  w = 300
  h = 400
  LeftPosition = if screen.width then (screen.width-w)/2 else 0
  TopPosition = if screen.height then (screen.height-h)/2 else 0
  settings = 'height='+h+', width='+w+' ,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,resizable'
  window.open("/checkAvailabilityPopup",'myWindow',settings)


Template.checkAvailability.events
  "click .btn": grab encapsulate (event, template) ->
    w = 300
    h = 400
    LeftPosition = if screen.width then (screen.width-w)/2 else 0
    TopPosition = if screen.height then (screen.height-h)/2 else 0
    settings = 'height='+h+', width='+w+' ,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,resizable'
    window.open("/checkAvailabilityPopup",'myWindow',settings)