Template.copyUrlBtn.onRendered ->
  @ZeroClipboardClient = new ZeroClipboard(@find('#copy-url-btn'))
  @ZeroClipboardClient.on "copy", (event) =>
    link = "#{window.location.href}?utm=admin_link"
    event.clipboardData.setData "text/plain", link
    event.clipboardData.setData "text/html", link

Template.copyUrlBtn.onDestroyed ->
  @ZeroClipboardClient.destroy()
