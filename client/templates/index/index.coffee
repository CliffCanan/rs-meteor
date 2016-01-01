Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->
  #- Background slideshow
  $(".home-page-bg").vegas
    slides: [
      src: "/images/home-bg/philly2.png"
    ,
      src: "/images/home-bg/living-room.jpg"
    ,
      src: "/images/home-bg/bedroom.png"
    ,
      src: "/images/home-bg/kitchen.png"
    ,
      src: "/images/home-bg/living-room2.jpg"
    ]
    #-overlay: "landlordlandingpage/assets/img/backgrounds/overlays/06.png"
    delay: 8500
    transition: [ "blur", "blur2", "fade" ]
    transitionDuration: 1500
    #walk: (index, slideSettings) ->
    #  $("#top-carousel").carousel "prev"




Template.index.events
  "click .head-section-wrap": (event, template) ->
    $('.city-list').slideUp()
  "click #expert-button": grab encapsulate (event, template) ->
    analytics.track "Clicked Work with an expert button"
    $('#contactUsPopup').modal('show')
  "click #browse-button": (event, template) ->
    event.stopPropagation()
    event.preventDefault()
    analytics.track "Clicked Browse Listings button"
    $('.city-list').slideToggle()

$(window).scroll ->
  "use strict"
  scroll = $(window).scrollTop()
  if scroll > 500 or ($(window).width() < 800 and scroll > 100)
    $("header").addClass "navbar-dark"
  else
    $("header").removeClass "navbar-dark"
