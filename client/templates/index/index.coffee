Template.index.helpers
  getCityData: ->
    cityId: @key
Template.index.rendered = ->

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
