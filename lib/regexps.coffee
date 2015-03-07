@createTextSearchRegexp = (text, bounds = false) ->
  text = escapeRegexp(text)
  if bounds
    if bounds is "left"
      text = "^" + text
    else if bounds is "right"
      text = text + "$"
    else
      text = "^" + text + "$"
  new RegExp(text, "i")

@escapeRegexp = (text) ->
  text.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
