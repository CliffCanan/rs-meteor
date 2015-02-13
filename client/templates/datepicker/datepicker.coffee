Template.datepicker.helpers
#  helper: ->

Template.datepicker.rendered = ->
  $input = @$("input")
  $input.datepicker(
    changeMonth: true
    changeYear: true
    dateFormat: "mm/dd/yy"
  )

Template.datepicker.events
#  "click .selector": (event, template) ->
