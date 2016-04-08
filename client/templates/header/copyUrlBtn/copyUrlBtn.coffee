Template.copyUrlBtn.onRendered ->
  @ZeroClipboardClient = new ZeroClipboard(@find('#copy-url-btn'))
  @ZeroClipboardClient.on "copy", (event) =>
    event.clipboardData.setData "text/plain", window.location.href
    event.clipboardData.setData "text/html", window.location.href

Template.copyUrlBtn.onDestroyed ->
  @ZeroClipboardClient.destroy()
