FastRender.onAllRoutes (path) ->
  @subscribe("meteor.loginServiceConfiguration")
  @subscribe("currentUser")

