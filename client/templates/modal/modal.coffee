Template.modal.helpers
#  helper: ->

Template.modal.rendered = ->
  modal = @firstNode
  $(".modal").each (index, existingModal) ->
    if existingModal isnt modal
      $(existingModal).modal("hide")
  view = @view
  $modal = $(modal)
  $modal.modal()
  $modal.on("hidden.bs.modal", ->
    Blaze.remove(view)
  )

Template.modal.events
