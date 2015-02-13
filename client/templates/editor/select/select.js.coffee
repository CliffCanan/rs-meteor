Template.select.helpers
  placeholder: ->
    @placeholder or i18n.t(@placeholderI18n)
  disabled: ->
    not (if _.isBoolean(@enabled) then @enabled else true)
  optionSelected: (context) ->
    if context.multiple
      @value in context.value
    else
      @value is context.value

Template.select.rendered = ->
  editor = @firstNode
  $editor = $(editor)
#  editor = EditorCache.editors[@data.family]
#  if editor.isEditedProperty(@data._id, @data.property)
#    $activeElement = $(document.activeElement)
#    if $editor.get(0) isnt document.activeElement and (not $activeElement.closest("textarea, input").length or $activeElement.attr("data-family") and $activeElement.attr("data-family") is $editor.attr("data-family"))
#      if @data.isNew
#        $editor.select()
#      else
#        $editor.focusToEnd()

Template.select.events
  "change .property-editor": encapsulate (event, template) ->
    $set = {}
    value = $(event.currentTarget).val()
    if not value
      if template.data.multiple
        value = []
      else
        value = null
    $set[template.data.property] = value
    editor = EditorCache.editors[template.data.family]
    editor.collection.update(template.data._id, {$set: $set})
