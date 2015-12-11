Template.datepicker.helpers
#  helper: ->

Template.datepicker.rendered = ->
  $input = @$("input")
  options = 
    changeMonth: true
    changeYear: true
    dateFormat: "mm/dd/yy"
    minDate: new Date()

  if @data.options
    options = _.extend(options, @data.options)
  $input.datepicker options

Template.datepicker.events
#  "click .selector": (event, template) ->
