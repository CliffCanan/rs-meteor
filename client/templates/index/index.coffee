Template.index.helpers
  getCityData: ->
    cityId: @key

Template.index.rendered = ->

  if $('main').hasClass('container')
    $('main').removeClass('container')
  
  #- Background slideshow
  $(".home-page-bg").vegas
    slides: [
      src: "/images/home-bg/philly2.png"
      transition: "fade"
      transitionDuration: 750
    ,
      src: "/images/home-bg/living-room.jpg"
    ,
      src: "/images/home-bg/bedroom.png"
    ,
      src: "/images/home-bg/kitchen.png"
    ,
      src: "/images/home-bg/living-room2.jpg"
    ]
    delay: 8500
    overlay: "/images/home-bg/overlays/06.png"
    #-shuffle: true
    transition: [ "blur", "blur2", "fade" ]
    transitionDuration: 1750
    #-walk: (index, slideSettings) ->

  unless $("body").getNiceScroll().length > 0
    console.log("Index -> firing nicescroll")

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


Template.index.events
  "click .head-section-wrap": (event, template) ->
    $('.city-list').slideUp()

  "click #expert-button": grab encapsulate (event, template) ->
    analytics.track "Clicked Talk With An Expert Button" unless Meteor.user()
    $('#contactUsPopup').modal('show')

  "click #browse-button": (event, template) ->
    event.stopPropagation()
    event.preventDefault()
    analytics.track "Clicked Browse Listings Button" unless Meteor.user()
    $('.city-list').slideToggle()

  "click #getStarted": grab encapsulate (event, template) ->
    analytics.track "Clicked Get Started Button" unless Meteor.user()
    $('#contactUsPopup').modal('show')


$("#contactUsPopup").on "shown.bs.modal", (e) ->
  Session.set "hasSeenContactUsPopup", true

$(window).scroll ->
  "use strict"
  scroll = $(window).scrollTop()
  if scroll > 400 or ($(window).width() < 800 and scroll > 90)
    $("header").addClass "navbar-dark"
  else
    $("header").removeClass "navbar-dark"
