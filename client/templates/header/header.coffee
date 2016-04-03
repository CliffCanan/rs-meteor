Template.city.onRendered ->
  instance = @

  console.log(Iron.Location.get().path)
  Session.set("currentPath", Iron.Location.get().path)

  client = new ZeroClipboard($('#copy-url-btn'))

  client.on 'ready', (e) ->
    console.log '1. zeroclipboard loaded'

    client.on 'aftercopy', (e) ->
      console.log 'Copied text to clipboard: ' + e.data['text/plain']

  client.on 'error', (e) ->
    console.log('ZeroClipboard error of type "' + event.name + '": ' + event.message);
    ZeroClipboard.destroy()

Template.header.helpers
  loggedInUser: ->
    Meteor.user()

  canManageClients: ->
    canManage = Security.canManageClients()
    if canManage
      $('body').addClass('admin-logged-in') 
    else
      $('body').removeClass('admin-logged-in') 
    canManage

  recommendationsClientName: ->
    clientObject = Session.get("recommendationsClientObject")
    clientObject.name

  isDesktop: ->
    $(window).width() > 992

  currentUrl: ->
    path = "https://www.rentscene.com"
    path += Session.get("currentPath")
    path

Template.header.onRendered ->
  @autorun ->
    height = $('header').height() - 1
    height += 52 if share.canRecommend()

    $('main').css('margin-top': height)


  unless $("body").getNiceScroll().length > 0
    #console.log("Header -> firing nicescroll")

    $("body").niceScroll
      bouncescroll: true
      cursorborder: 0
      cursorborderradius: "10px"
      cursorcolor: "#404142"
      cursorwidth: "9px"
      zindex: 9999
      mousescrollstep: 30 # default is 40 (px)
      scrollspeed: 42 # default is 60
      autohidemode: "cursor"
      hidecursordelay: 700
      horizrailenabled: false

Template.header.events
  "click .contact-us": grab encapsulate (event, template) ->
    analytics.track "Clicked Contact Us Header Btn" unless Meteor.user()
    $('#contactUsPopup form').formValidation 'resetForm', true
    $('#contactUsPopup').modal('show')

  "click #view-recommendations": (event, template) ->
    event.preventDefault()
    analytics.track "Clicked View Recommendations Btn" unless Meteor.user()
    clientObject = Session.get("recommendationsClientObject")
    Session.set "showRecommendations", true
    Router.go "clientRecommendations", clientId: clientObject.clientId
    return

  "click #exit-recommendation": (event, template) ->
    event.preventDefault()
    share.exitRecommendationsMode()
    return