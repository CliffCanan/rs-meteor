Template.copyUrlBtn.onRendered ->
  @ZeroClipboardClient = new ZeroClipboard(@find('#copy-url-btn'))
  @ZeroClipboardClient.on "copy", (event) =>
    uri = new Uri(location.href)
    uri.addQueryParam("utm_source", "admin_link")
    link = uri.toString()
    event.clipboardData.setData "text/plain", link
    event.clipboardData.setData "text/html", link

Template.copyUrlBtn.onDestroyed ->
  @ZeroClipboardClient.destroy()
