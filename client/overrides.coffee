Template._loginButtonsLoggedOutDropdown.rendered = ->
  Accounts._loginButtonsSession.set("inSignupFlow", true)
  $a = @$("a.dropdown-toggle")
  $a.addClass("navigation-item-link")
  $a.find(".caret").remove()
  $a.text("Login")
  $a.parent().children("div").addClass("dropdown-menu-right")

  $dropdown = $a.closest(".dropdown")
  $dropdown.find(".btn-Google").addClass("btn-lg")
  $dropdown.on("click", (event) ->
    $target = $(event.target)
    if $target.is(".dropdown-menu")
      event.stopPropagation()
      event.stopImmediatePropagation()
  )
  # I added @ before $ to scope it down... not sure what's going on here
  @$(".col-sm-12").addClass("col-xs-12").removeClass("col-sm-12")

Template._loginButtonsLoggedInDropdown.rendered = ->
  Accounts._loginButtonsSession.set("inSignupFlow", true)
  $a = @$("a.dropdown-toggle")
  $a.addClass("navigation-item-link")
  $a.find(".caret").remove()
  $a.parent().children("div").addClass("dropdown-menu-right")
  # I added @ before $ to scope it down... not sure what's going on here
  @$(".col-sm-12").addClass("col-xs-12").removeClass("col-sm-12")
#Blaze._reportException = (e, msg) ->
#  console.log(msg)
#  throw e
