Template.textarea.helpers
  placeholder: ->
    @placeholder or i18n.t(@placeholderI18n)
  value: ->
    $element = $("[data-family='" + @family + "'][data-object-id='" + @_id + "'][name='" + @property + "']")
    element = $element.get(0)
    if not element or element isnt document.activeElement
      editor = EditorCache.editors[@family]
      object = editor.collection.findOne(@_id)
      if not object # not sure why it happens
        return
      object[@property]
    else
      $element.val()

Template.textarea.rendered = ->
  _id = @data._id
  property = @data.property
  element = @firstNode
  $element = $(element)
  $element.autosize(
    append: ""
  )
  editor = EditorCache.editors[@data.family]
  if editor.isEditedProperty(@data._id, @data.property)
    $activeElement = $(document.activeElement)
    if $element.get(0) isnt document.activeElement and (not $activeElement.closest("textarea, input").length or $activeElement.attr("data-family") and $activeElement.attr("data-family") is $element.attr("data-family"))
      if @data.isNew
        $element.select()
      else
        $element.focusToEnd()

Template.textarea.events
  "focus .property-editor": encapsulate (event, template) ->
    editor = EditorCache.editors[template.data.family]
    editor.setEditingProperty(template.data._id, template.data.property)
  "keydown .property-editor": encapsulate (event, template) ->
    $editor = $(event.target)
    editor = EditorCache.editors[template.data.family]
    data = template.data
    switch event.keyCode
      when 27 # Escape
        event.preventDefault()
        editor.stopEditing(data._id)
      else
      # noop
  "keyup, paste .property-editor": encapsulate (event, template) ->
    $editor = $(event.target)
    editor = EditorCache.editors[template.data.family]
    editor.debouncedSaveProperty(template.data._id, template.data.property, $editor.val())
