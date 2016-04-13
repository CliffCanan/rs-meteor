Template.copyUrlBtn.onRendered ->
  @ZeroClipboardClient = new ZeroClipboard(@find('#copy-url-btn'))
  @ZeroClipboardClient.on "copy", (event) =>
    uri = new Uri(location.href)
    uri.addQueryParam("utm_source", "admin_link")
    link = uri.toString()
    event.clipboardData.setData "text/plain", link
    event.clipboardData.setData "text/html", link

    toastr.options =
      "closeButton": true,
      "positionClass": "toast-top-right"

    toastr.success(link,'URL Copied To Clipboard')

Template.copyUrlBtn.onDestroyed ->
  @ZeroClipboardClient.destroy()
