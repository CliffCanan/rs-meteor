Template.connection.helpers
  stats: ->
    status = Meteor.connection.status()
    switch status.status
      when "connected"
        {
          cls: "fa-bolt"
          content: "Connected to server, life is good!"
        }
      when "connecting"
        if status.retryCount
          {
            cls: "fa-spinner fa-spin text-warning"
            content: "Reconnecting to server..."
          }
        else
          {
            cls: "hidden"
            content: "Connecting to server..."
          }
      when "waiting"
        retryDate = new Date(status.retryTime)
        retryTimeString = retryDate.toTimeString()
        {
          cls: "fa-exclamation-circle text-warning"
          content: "Disconnected from server. Tried to reconnect #{status.retryCount} times, will try again at #{retryTimeString.substr(0, retryTimeString.indexOf(" "))} (<a href='#' class='reconnect'>reconnect now</a>)."
        }
      when "failed"
        {
          cls: "fa-exclamation-triangle text-danger"
          content: "Disconnected from server. " + status.reason
        }
      else
        throw new Error("Unknown status: '#{status.status}'")

Template.connection.rendered = ->
  hasBeenDisconnected = false
  hideTimeout = null
  $reconnect = $(@firstNode)
  $reconnect.popover(
    html: true
    container: document.body
    placement: "left"
    trigger: "manual"
  )
  showPopover = ->
    _.defer =>
      $reconnect.show()
      $reconnect.data('bs.popover').options.content = $reconnect.attr("data-content")
      $reconnect.popover("show")
  @autorun =>
    status = Meteor.connection.status()
    if status.status is "connected"
      if hasBeenDisconnected
        if Meteor.settings.public.isDebug # hide immediately
          $reconnect.popover("hide")
          $reconnect.hide()
        else # show off how cool we are for reconnecting to server
          showPopover()
          hideTimeout = setTimeout(->
            $reconnect.popover("hide")
            $reconnect.hide(400)
          , 2000)
      else
        $reconnect.popover("hide")
        $reconnect.hide()
    else
      hasBeenDisconnected = status.retryCount
      showPopover()


Template.connection.events
# handled via document listener
